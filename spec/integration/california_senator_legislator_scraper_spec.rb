require "rails_helper"

RSpec.describe CaliforniaSenatorLegislatureScraper, :type => :model do

  it "should get names of all members in senator roster" do
    contents = File.open("spec/integration/examples/senators_wikipedia_2014_example.html").read
    net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
    my_response = RestClient::Response.create(contents, net_http_resp, nil)
    expect(RestClient).to receive(:get) {
      my_response
    }
    legislators = CaliforniaSenatorLegislatureScraper.get_california_legislators()
    expect(legislators.length).to eq(129)
    legislator = legislators.first
    expect(legislator.first_name).to eq("Ted")
    expect(legislator.last_name).to eq("Gaines")
    expect(legislator.party).to eq("Republican")
    wut = legislators.select{|legislator| legislator.first_name == "Republican"}
    wut.map {|w|
      puts w.to_json}
    expect(legislators.select{|legislator| legislator.first_name == "Republican"}.length).to eq(0)
    expect(legislators.select{|legislator| legislator.first_name == "Democratic"}.length).to eq(0)

  end
end