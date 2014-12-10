namespace :retrieve_data do
  desc "retrieves info"
  task get_bill_headers: :environment do
    AssemblyBillHeader.where(:year => "2014").destroy
    CaliforniaWebCrawler.refreshAvailableBillsForYear("2014")
end

  task get_bill_voting_sessions: :environment do
    bill = AssemblyBillHeader.where(:billNumber => "2").where(:billType => "HR").first
    CaliforniaWebCrawler.storeVotingHistoriesFor(bill)
  end

end
