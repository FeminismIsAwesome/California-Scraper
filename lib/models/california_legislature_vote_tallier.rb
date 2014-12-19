class CaliforniaLegislatureVoteTallier


  def self.getVotesFor(legislator, year="2014")
    votes = Hash.new
    yesBills = getVotesOf("ayes", legislator, year)
    noBills = getVotesOf("noes", legislator, year)
    absentBills = getVotesOf("absent",legislator, year)
    votes["yes"] = yesBills
    votes["no"] = noBills
    votes["absent"] = absentBills
    votes
  end

  def self.saveVotesFor(legislator, year="2014")
    voteTypes = self.getVotesFor(legislator, year)
    votes = voteTypes.values.reject{|val| val.nil?}.reduce(:+)
    votes.each do |vote|
      vote.save
    end
  end

  def self.getVotesOf(type, legislator, year)
    bills = fetchBillsGivenAmbivalentName(legislator, type, year)
    bills.map {|bill|
      vote = VotingRecord.new
      vote.bill_number = bill.billNumber
      vote.bill_type = bill.billType
      vote.legislator = legislator
      vote.vote = type
      vote.year = year
      vote
    }
  end

  def self.fetchBillsGivenAmbivalentName(legislator, type, year)
    yesBillsWithLastName = Bill.where(:year => year).in("votingSessions.#{type}" => legislator.last_name)
    if (yesBillsWithLastName.count == 0)
      Bill.where(:year => year).in("votingSessions.#{type}" => legislator.full_name)
    else
      yesBillsWithLastName
    end
  end
end