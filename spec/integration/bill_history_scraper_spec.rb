RSpec.describe "california web crawler", :type => :model do
  it "should query bills" do
    bill = AssemblyBillHeader.new(2, "AB")
    puts CaliforniaWebCrawler.getHistoryFor(bill)
  end
end