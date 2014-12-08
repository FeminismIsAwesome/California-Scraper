require "rails_helper"

RSpec.describe "california web crawler", :type => :model do
  it "should query bills" do
    bill = AssemblyBillHeader.new(billNumber: 2, billType: "AB")
    billHistory = CaliforniaWebCrawler.getHistoryFor(bill)
    expect(billHistory["2014"][0]).to match(/Feb\. 3	From committee/)
    expect(billHistory["2013"][0]).to match(/Apr\. 16	Re-referred/)
    expect(billHistory["2012"][0]).to match(/Dec\. 4	From printer/)
  end
  it "should store the list of bills currently available" do
    file = File.open("spec/integration/bill_list_small_example.txt")
    contents = file.read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    allow(RestClient).to receive(:get) {
      my_response
    }
    billHeaders = CaliforniaWebCrawler.refreshAvailableBillsForYear("2014")
    expect(AssemblyBillHeader.count).to eq(7)


  end


end