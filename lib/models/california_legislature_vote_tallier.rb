class CaliforniaLegislatureVoteTallier


  def self.getVotesFor(legislator, year="2014")
    votes = Hash.new
    yesBills = getVotesOf("ayes", legislator, year)
    noBills = getVotesOf("noes", legislator, year)
    votes["yes"] = yesBills.map(&:formatted_bill_header)
    votes["no"] = noBills.map(&:formatted_bill_header)
    votes
  end

  def self.getVotesOf(type, legislator, year)
    yesBillsWithLastName = Bill.where(:year => year).in("votingSessions.#{type}" => legislator.last_name)
    if(yesBillsWithLastName.count == 0)
      Bill.where(:year => year).in("votingSessions.#{type}" => legislator.full_name)
    end
  end
end