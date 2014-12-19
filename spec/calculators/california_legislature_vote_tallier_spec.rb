require "rails_helper"

RSpec.describe CaliforniaLegislatureVoteTallier, :type => :model do
  let!(:legislator1) {Legislator.create(first_name: "Laura", last_name:"Cruz")}
  let!(:legislator2) {Legislator.create(first_name: "Laura", last_name:"Perry")}
  let!(:legislator3) {Legislator.create(first_name: "Bob", last_name:"Dole")}
  let!(:votingSession1) {VotingSession.new(ayes: ["Laura Cruz", "Dole"])}
  let!(:votingSession2) {VotingSession.new(ayes: ["Dole"], noes: ["Laura Perry"])}
  let!(:votingSession3) {VotingSession.new(ayes: ["Laura Norris", "Dole"], noes: [])}
  let!(:bill) { Bill.create(billNumber:"1", billType:"AB", year:"2014", votingSessions: [votingSession1])}
  let!(:bill2) { Bill.create(billNumber:"1", billType:"SB", year:"2014", votingSessions: [votingSession2])}
  let!(:bill3) { Bill.create(billNumber:"22", billType:"AB", year:"2014", votingSessions: [votingSession3])}
  let!(:bill4) { Bill.create(billNumber:"22", billType:"AB", year:"2013", votingSessions: [votingSession1])}

  it "should assign votes based off legislator" do
    votes = CaliforniaLegislatureVoteTallier.getVotesFor(legislator1)
    expect(votes["yes"].length).to eq(1)
    expect(votes["no"].length).to eq(0)
    expect(votes["yes"][0].legislator).to eq(legislator1)
  end

  it "should get votes " do

  end
end
