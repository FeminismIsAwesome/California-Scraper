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

  def get_votes_for_bills_and_legislators
    legislators = Legislator.all.to_a
    bills = params[:bills].map {|bill| 
      splitBillBySpace = bill.split(" ")
      Bill.new(
        :billNumber => splitBillBySpace[1],
        :billType => splitBillBySpace[0]
      )
    }
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