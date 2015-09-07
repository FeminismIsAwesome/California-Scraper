class CaliforniaLegislatorDataService

  def self.getVotesAndBillsForLegislator(bills, legislator, year = "2014")
    billIdentities = bills.map{|bill| 
      "#{bill.billType}#{bill.billNumber}"
    }
    return VotingRecord.where(:year => year).in(:bill_identity => billIdentities).where(:legislator => legislator)
  end

  def self.getVotesAndBillsForLegislators(bills, legislators, year = "2014")
  	billIdentities = bills.map{|bill| 
      "#{bill.billType}#{bill.billNumber}"
    }
    return VotingRecord.where(:year => year).in(:bill_identity => billIdentities).in(:legislator => legislators)
  end

end