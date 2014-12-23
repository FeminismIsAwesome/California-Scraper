require "rails_helper"

RSpec.describe CaliforniaAssemblyLegislatureScraper, :type => :model do

  it "should get names of all members in roster" do
    contents = File.open("spec/integration/examples/senators_and_assembly/assembly.html").read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    expect(RestClient).to receive(:get) {
      my_response
    }
    legislators = CaliforniaAssemblyLegislatureScraper.getCaliforniaAssembly()
    expect(legislators.length).to eq(80)
  end

  it "should get first assembly person's detail in roster" do
    contents = File.open("spec/integration/examples/senators_and_assembly/assembly.html").read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    expect(RestClient).to receive(:get) {
      my_response
    }
    legislators = CaliforniaAssemblyLegislatureScraper.getCaliforniaAssembly()
    first_legislator = legislators.first
    expect(first_legislator.first_name).to eq("Katcho")
    expect(first_legislator.last_name).to eq("Achadjian")
    expect(first_legislator.middle_name).to be_nil
    expect(first_legislator.party).to eq("Republican")
    expect(first_legislator.house).to eq("Assembly")
    expect(first_legislator.district).to eq("35")
    expect(first_legislator.capital_phone).to eq("(916) 319-2035")
    expect(first_legislator.room_number).to eq("P.O. Box 942849, Room 4098, Sacramento, CA 94249-0035; (916) 319-2035")
    expect(first_legislator.email).to eq("https://lcmspubcontact.lc.ca.gov/PublicLCMS/ContactPopup.php?district=AD35")
    expect(first_legislator.state).to eq("CA")
  end
end