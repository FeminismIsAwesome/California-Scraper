require "rails_helper"

RSpec.describe "california web crawler", :type => :model do
  it "should query bills" do
    file = File.open("spec/integration/examples/bill_history_example_basic.html")
    contents = file.read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    allow(RestClient).to receive(:get) {
      my_response
    }
    bill = AssemblyBillHeader.new(billNumber: 2, billType: "AB")
    billHistory = CaliforniaWebCrawler.getHistoryFor(bill)
    expect(billHistory["2014"][0]).to match(/Feb\. 3	From committee/)
    expect(billHistory["2013"][0]).to match(/Apr\. 16	Re-referred/)
    expect(billHistory["2012"][0]).to match(/Dec\. 4	From printer/)
  end
  it "should store the list of bills currently available" do
    file = File.open("spec/integration/examples/bill_list_small_example.txt")
    contents = file.read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    allow(RestClient).to receive(:get) {
      my_response
    }
    billHeaders = CaliforniaWebCrawler.refreshAvailableBillsForYear("2014")
    expect(AssemblyBillHeader.count).to eq(7)
    expect(AssemblyBillHeader.first.year).to eq("2014")
    expect(AssemblyBillHeader.first.billNumber).to eq("1")
    expect(AssemblyBillHeader.first.billType).to eq("AB")

  end

  it "should get the links for all the voting histories" do
    file = File.open("spec/integration/examples/bill_index_page_example.html")
    contents = file.read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    allow(RestClient).to receive(:get) {
      my_response
    }
    bill = AssemblyBillHeader.new(billNumber: 2, billType: "AB", year: 2014)
    votingHistories = CaliforniaWebCrawler.getVotingHistoryLinksFor(bill)
    expect(votingHistories.count).to eq(5)
    expect(votingHistories[0]).to eq("http://www.leginfo.ca.gov//pub/11-12/bill/asm/ab_0001-0050/ab_2_vote_20110822_000005_sen_comm.html")

  end

  it "should not get links when there all no voting history" do
    file = File.open("spec/integration/examples/no_votes_index.html")
    contents = file.read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    allow(RestClient).to receive(:get) {
      my_response
    }
    bill = AssemblyBillHeader.new(billNumber: 2, billType: "AB", year: 2014)
    votingHistories = CaliforniaWebCrawler.getVotingHistoryLinksFor(bill)
    expect(votingHistories.count).to eq(0)
  end

  it "should not get veto link but get other links" do
    file = File.open("spec/integration/examples/index_with_veto.html")
    contents = file.read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    allow(RestClient).to receive(:get) {
      my_response
    }
    bill = AssemblyBillHeader.new(billNumber: 2, billType: "AB", year: 2014)
    votingHistories = CaliforniaWebCrawler.getVotingHistoryLinksFor(bill)
    expect(votingHistories.count).to eq(8)
    expect(votingHistories[7]).to eq("http://www.leginfo.ca.gov//pub/13-14/bill/asm/ab_2751-2800/ab_2756_vote_20140428_000002_asm_comm.html")
  end


  it "should store the results of crawling" do
    allow(CaliforniaWebCrawler).to receive(:getVotingHistoryLinksFor){
      ["http://www.leginfo.ca.gov/pub/13-14/bill/asm/ab_0001-0050/ab_2_vote_20130402_000003_asm_comm.html"]
    }
    allow(CaliforniaWebCrawler).to receive(:getVotingHistoriesGiven) {
      [VotingSession.new(ayes: ["Fernando", "Peiying"], noes: ["Juan", "Perez"])]
    }
    bill = AssemblyBillHeader.new(billNumber: 2, billType: "AB", year:2014)
    CaliforniaWebCrawler.storeVotingHistoriesFor(bill)
    billResults = Bill.first
    expect(billResults.billType).to eq("AB")
    expect(billResults.votingSessions.count).to eq(1)
    expect(billResults.bill_url).to eq("http://www.leginfo.ca.gov/cgi-bin/postquery?bill_number=ab_2&sess=1314")
  end


end