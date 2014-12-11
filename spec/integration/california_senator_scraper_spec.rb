require "rails_helper"

RSpec.describe CaliforniaAssemblyLegislatureScraper, :type => :model do

  it "should get names of all members in senator roster" do
    contents = File.open("spec/integration/examples/senators_and_assembly/senators.html").read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    expect(RestClient).to receive(:get) {
      my_response
    }
    legislators = CaliforniaSenatorScraper.getCaliforniaSenators()
    expect(legislators.length).to eq(39)
  end

  it "should get first senator's detail in roster" do
    contents = File.open("spec/integration/examples/senators_and_assembly/senators.html").read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    expect(RestClient).to receive(:get) {
      my_response
    }
    legislators = CaliforniaSenatorScraper.getCaliforniaSenators()
    firstLegislator = legislators[0]
    expect(firstLegislator.first_name).to eq("Benjamin")
    expect(firstLegislator.last_name).to eq("Allen")
    expect(firstLegislator.middle_name).to be_nil
    expect(firstLegislator.state).to eq("CA")
    expect(firstLegislator.party).to eq("Dem")
    expect(firstLegislator.house).to eq("Senator")
    expect(firstLegislator.district).to eq("District 26")
    expect(firstLegislator.email).to eq("https://lcmspubcontact.lc.ca.gov/PublicLCMS/ContactPopup.php?district=SD26")
    expect(firstLegislator.capital_phone).to eq("(916) 651-4026")
  end
end