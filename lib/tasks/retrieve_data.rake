namespace :retrieve_data do
  desc "retrieves info"
  task get_bill_headers: :environment do
    AssemblyBillHeader.where(:year => "2014").destroy
    CaliforniaWebCrawler.refreshAvailableBillsForYear("2014")
end

  task get_bill_voting_sessions: :environment do
    Bill.all.destroy
    bills = AssemblyBillHeader.all.each do |bill|
      puts "storing bill #{bill.billType}-#{bill.billNumber}"
      CaliforniaWebCrawler.storeVotingHistoriesFor(bill)
      puts "~stored~ #{bill.billType}-#{bill.billNumber}"
    end
  end

end
