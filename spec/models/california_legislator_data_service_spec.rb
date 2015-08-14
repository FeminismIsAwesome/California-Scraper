
require "rails_helper"

RSpec.describe CaliforniaLegislatorDataService, :type => :model do
	let!(:legislator1) {Legislator.create(first_name: "Laura", last_name:"Cruz")}
	let!(:legislator2) {Legislator.create(first_name: "Rick", last_name:"Astley")}
	let!(:legislator3) {Legislator.create(first_name: "Sylvanus", last_name:"Windstriker")}
	
	it "should get votes for a given set of bills for a given senator" do
		bill = Bill.create(billNumber: "13", billType: "HR")
		bill2 = Bill.create(billNumber: "14", billType: "SB")
		bill3 = Bill.create(billNumber: "13", billType: "SB")
		votingRecord = VotingRecord.create(vote: "noes", year: "2014", voting_location: "ASM. FLOOR", legislator: legislator1, bill_identity:"HR13")
		votingRecord2 = VotingRecord.create(vote: "noes", year: "2014", voting_location: "ASM. FLOOR", bill_identity:"SB13", legislator: legislator2)
		votingRecord3 = VotingRecord.create(vote: "ayes", year: "2014", voting_location: "ASM. FLOOR", bill_identity:"SB14", legislator: legislator1)
		votes = CaliforniaLegislatorDataService.getVotesAndBillsForLegislator([bill, bill2], legislator1)
		expect(votes.length).to eq(2)
		expect(votes[0]).to eq(votingRecord)
		expect(votes[1]).to eq(votingRecord3)
	end

	it "should not get bills from other senators" do
		bill = Bill.create(billNumber: "13", billType: "HR")
		bill2 = Bill.create(billNumber: "14", billType: "SB")
		bill3 = Bill.create(billNumber: "13", billType: "SB")
		votingRecord = VotingRecord.create(vote: "noes", year: "2014", voting_location: "ASM. FLOOR", legislator: legislator1, bill_identity:"SB13")
		votingRecord2 = VotingRecord.create(vote: "noes", year: "2014", voting_location: "ASM. FLOOR", bill_identity:"HR13", legislator: legislator2)
		votingRecord3 = VotingRecord.create(vote: "ayes", year: "2014", voting_location: "ASM. FLOOR", bill_identity:"SB13", legislator: legislator3)
		votes = CaliforniaLegislatorDataService.getVotesAndBillsForLegislator([bill3], legislator1)
		expect(votes.length).to eq(1)
		expect(votes[0]).to eq(votingRecord)
		votes = CaliforniaLegislatorDataService.getVotesAndBillsForLegislator([bill],legislator2)
		expect(votes.length).to eq(1)
		expect(votes[0]).to eq(votingRecord2)
	end

	it "should get votes from multiple voting locations for same senator" do
		bill = Bill.create(billNumber: "13", billType: "HR")
		bill2 = Bill.create(billNumber: "14", billType: "SB")
		bill3 = Bill.create(billNumber: "13", billType: "SB")
		votingRecord = VotingRecord.create(vote: "noes", year: "2014", voting_location: "ASM. FLOOR", legislator: legislator1, bill_identity:"HR13")
		votingRecord2 = VotingRecord.create(vote: "noes", year: "2014", voting_location: "ASM. FLOOR", bill_identity:"SB13", legislator: legislator2)
		votingRecord3 = VotingRecord.create(vote: "ayes", year: "2014", voting_location: "SEN. FLOOR", bill_identity:"HR13", legislator: legislator1)
		votes = CaliforniaLegislatorDataService.getVotesAndBillsForLegislator([bill], legislator1)
		expect(votes.length).to eq(2)
		expect(votes[0]).to eq(votingRecord)
		expect(votes[1]).to eq(votingRecord3)
	end

end