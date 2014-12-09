namespace :retrieve_data do
  desc "retrieves info"
  task get_bill_headers: :environment do
    CaliforniaWebCrawler.refreshAvailableBillsForYear("2014")
  end

end
