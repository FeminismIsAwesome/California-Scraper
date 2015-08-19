class CaliforniaLegislatorDataService

  def self.getVotesAndBillsForLegislator(bills, legislator)
    billIdentities = bills.map{|bill| 
      "#{bill.billType}#{bill.billNumber}"
    }
    return VotingRecord.in(:bill_identity => billIdentities).where(:legislator => legislator)
  end

  def self.getVotesAndBillsForLegislators(bills, legislators)
  	billIdentities = bills.map{|bill| 
      "#{bill.billType}#{bill.billNumber}"
    }
    return VotingRecord.in(:bill_identity => billIdentities).in(:legislator => legislators)
  end

end