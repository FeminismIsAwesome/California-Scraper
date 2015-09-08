class Api::LegislatorsController < ApplicationController
  respond_to :json
  def bills
    full_name = params[:legislator_id]
    names = get_first_and_last_name_from(full_name)
    legislator = Legislator.where(:last_name => names[:last_name])
    if names[:first_name]
      legislator = legislator.where(:first_name => names[:first_name])
    end
    respond_with CaliforniaLegislatureVoteTallier.getVotesFor(legislator.first)
  end

  def get_votes_for_legislators_in_pdf
    @bills = params[:bills].map{|bill| 
        Bill.where(:billNumber => bill.split(" ")[1]).where(:billType => bill.split(" ")[0]).first
    }
    bills = params[:bills]

    @votes_by_user = get_votes_for_all_legislators_grouped_by_legislator()
    @votes_by_user = @votes_by_user.map {|legislatorWithVote|
      votes = legislatorWithVote[:votes].sort_by{|v| v.date}.reverse
      votesInOrder = []
      bills.each_with_index do |bill, index|
        votes.each do |vote|
          if bill.gsub(" ", "") == vote.bill_identity && (vote.voting_location =="SEN. FLOOR" || vote.voting_location == "ASM. FLOOR")
            votesInOrder.push(vote.vote)
            break
          end
        end
        if votesInOrder.length <= index
          votesInOrder.push("no information")
        end
      end
      {
        legislator: legislatorWithVote[:legislator],
        votes: votesInOrder
      }
    }
    respond_to do |format| 
      format.pdf do
        render pdf: "file_name", layout: 'pdf', template:'pdfs/votes.html.erb'   # Excluding ".pdf" extension.
      end
    end 
  end

  def get_votes_for_legislators_in_csv
    @bills = params[:bills]
    @votes_by_user = get_votes_for_all_legislators_grouped_by_legislator() 
    respond_to do |format| 
      format.csv {send_data format_in_csv(@votes_by_user, @bills, {})}
    end 
  end

  def format_in_csv(votes_by_legislator,bills,options)
    CSV.generate(options) do |csv|
      csv << ["Assembly member","Party","District"] + bills
      votes_by_legislator.each do |vote_with_legislator|
        legislator = vote_with_legislator[:legislator]
        votes = vote_with_legislator[:votes]
        votes = votes.sort_by{|v| v.date}.reverse
        votesInOrder = []
        bills.each_with_index do |bill, index|
          votes.each do |vote|
            if bill.gsub(" ", "") == vote.bill_identity && (vote.voting_location =="SEN. FLOOR" || vote.voting_location == "ASM. FLOOR")
              votesInOrder.push(vote.vote)
              break
            end
          end
          if votesInOrder.length <= index
            votesInOrder.push("no information")
          end
        end
        csv << [legislator["first_name"] + " " + legislator["last_name"], legislator["party"], legislator["district"]] + votesInOrder
      end
    end
  end

  def get_legislators_by_zip_code
    districts = ZipCode.where(:zipCode => params[:zip_code]).map {|zipCode|
      code = zipCode.districtCode
      if(code[0] == "0")
        code = code[1..code.length]
      else
        code
      end
    }
    puts "HI"
    puts districts.length
    puts districts.to_json
    puts "BYE"
    if districts.length > 0 
      respond_with Legislator.in(:district => districts)
    else
      respond_with []
    end
  end

  def index
    respond_with Legislator.all
  end

  def get_legislator_from full_name
    full_name = params[:legislator_name]
    names = get_first_and_last_name_from(full_name)
    legislator = Legislator.where(:last_name => names[:last_name])
    if names[:first_name]
      legislator = legislator.where(:first_name => names[:first_name])
    end
    return legislator
  end

  def get_votes_for_all_legislators_grouped_by_legislator

    legislators = Legislator.all.to_a
    bills = params[:bills].map {|bill| 
      splitBillBySpace = bill.split(" ")
      Bill.new(
        :billNumber => splitBillBySpace[1],
        :billType => splitBillBySpace[0]
      )
    }
    bills_cache_identity = bills.map{|bill| bill.billType + bill.billNumber }.join(",")
    if(Rails.cache.read(bills_cache_identity))
      return Rails.cache.read(bills_cache_identity)
    end

    myCounter = 0
    @votes = CaliforniaLegislatorDataService.getVotesAndBillsForLegislators(bills, legislators).to_a

    @votes_by_user = {}
    @votes.each do |vote|
      if @votes_by_user[vote.legislator]
        @votes_by_user[vote.legislator] += [vote]
      else
        @votes_by_user[vote.legislator] = [vote]
      end
    end

    legislators.each do |legislator| 
      if @votes_by_user[legislator] == nil
        @votes_by_user[legislator] = []
      end
    end

    @votes_by_user = @votes_by_user.reduce([]) {|memo, (legislator, votes)| memo += [{
      legislator: legislator.as_json,
      votes: votes
      }]}
    Rails.cache.write(bills_cache_identity, @votes_by_user)
    return @votes_by_user
  end

  def get_votes_for_bills_and_legislators
    @votes_by_user = get_votes_for_all_legislators_grouped_by_legislator()
    respond_with(@votes_by_user) do |format|
      format.json { render :json => @votes_by_user.as_json }
    end
  end

  def get_votes_for_bills
    puts params[:bills]
    bills = params[:bills].map {|bill| 
      splitBillBySpace = bill.split(" ")
      Bill.new(
        :billNumber => splitBillBySpace[1],
        :billType => splitBillBySpace[0]
      )
    }
    legislator = get_legislator_from(params[:legislator_name])
    @votes = CaliforniaLegislatorDataService.getVotesAndBillsForLegislator(bills, legislator.first)
    respond_with(@votes) do |format|
      format.json { render :json => @votes.as_json }
    end
  end

  def get_first_and_last_name_from full_name
    names = full_name.split(" ")
    if(names.length == 1)
      {:last_name => names[0]}
    else
      {:first_name => names[0], :last_name => names[1]}
    end
  end

end