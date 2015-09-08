require 'rails_helper'


describe Api::LegislatorsController do

  let!(:legislator1) {Legislator.create(first_name: "Laura", last_name:"Cruz")}
  let!(:legislator2) {Legislator.create(first_name: "Laura", last_name:"Perry")}
  let!(:legislator3) {Legislator.create(first_name: "Bob", last_name:"Dole")}
  let!(:votingSession1) {VotingSession.new(ayes: ["Laura Cruz", "Dole"])}
  let!(:votingSession2) {VotingSession.new(ayes: ["Dole"], noes: ["Laura Perry"])}
  let!(:votingSession3) {VotingSession.new(ayes: ["Laura Norris", "Dole"], noes: [])}
  let!(:votingRecord1) {VotingRecord.create(legislator: legislator1, bill_identity: "AB1", voting_location: "ASM. FLOOR",vote: "ayes")}
  let!(:votingRecord2) {VotingRecord.create(legislator: legislator2, bill_identity: "AB1", voting_location: "ASM. FLOOR",vote: "ayes")}
  let!(:votingRecord3) {VotingRecord.create(legislator: legislator1, bill_identity: "SB1", voting_location: "ASM. FLOOR",vote: "ayes")}
  let!(:bill) { Bill.create(billNumber:"1", billType:"AB", year:"2014", votingSessions: [votingSession1])}
  let!(:bill2) { Bill.create(billNumber:"1", billType:"SB", year:"2014", votingSessions: [votingSession2])}
  let!(:bill3) { Bill.create(billNumber:"22", billType:"AB", year:"2014", votingSessions: [votingSession3])}
  let!(:bill4) { Bill.create(billNumber:"22", billType:"AB", year:"2013", votingSessions: [votingSession1])}

  it "should get a list of all legislators" do
    get :index, format: :json
    expect(json.length).to eq(3)
  end

  it "should get a list of all bills for a given author" do
    get :bills, legislator_id: "Laura Perry", format: :json
    expect(json["yes"].length).to eq(0)
    expect(json["no"].length).to eq(1)

  end

  it "should get a list of bills with votes grouped by legislator" do 
    get :get_votes_for_bills_and_legislators, :bills => ["SB 1", "AB 1"], format: :json
    expect(json.length).to eq(3)
    previousCall = json
    # expect(Rails.cache.read("AB1,SB1").length).to eq(3)
    get :get_votes_for_bills_and_legislators, :bills => ["SB 1", "AB 1"], format: :json
    expect(json).to eq(previousCall)
  end

  it "should get a list of all bills for a given with only a last name" do
    get :bills, legislator_id: "Dole", format: :json
    expect(json.length).to eq(3)
    expect(json["yes"].length).to eq(3)
    expect(json["no"].length).to eq(0)

  end

end