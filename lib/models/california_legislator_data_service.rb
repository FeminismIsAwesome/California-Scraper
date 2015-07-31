class CaliforniaLegislatorDataService

  def self.getVotesAndBillsForLegislator(bills, legislator)
    billIdentities = bills.map{|bill| 
      "#{bill.billType}#{bill.billNumber}"
    }
    return VotingRecord.in(:bill_identity => billIdentities).where(:legislator => legislator)
  end

end