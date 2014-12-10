#encoding: ISO-8859-1
require "rails_helper"

RSpec.describe "voting history scraper", :type => :model do
  Encoding.default_external = "ISO-8859-1"
  Encoding.default_internal = "ISO-8859-1"
  noNoNotesFile = File.open("spec/integration/voting_history_example.html")
  noYesVotesFile = File.open("spec/integration/no_yes_votes_session.html")
  manyVotesFile = File.open("spec/integration/examples/many_votes_with_accents.html")
  sessionWithAccentsFile = File.open("spec/integration/examples/few_votes_with_accents.html", )

  sampleHistoryWith0NoVotes = noNoNotesFile.read
  sampleHistoryWith0YesVotes = noYesVotesFile.read
  sampleSessionWithManyVotes = manyVotesFile.read
  sessionWithAccents = sessionWithAccentsFile.read

  it "should get voting noes history as noes when none exist" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sampleHistoryWith0NoVotes)
    expect(voting_history.noes.length).to eq(0)
  end

  it "should get no yes votes when none exist" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sampleHistoryWith0YesVotes)
    expect(voting_history.ayes.length).to eq(0)
  end

  it "should get voting ayes history" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sampleHistoryWith0NoVotes)
    expect(voting_history.ayes.length).to eq(6)
  end

  it "should get voting noes history" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sampleHistoryWith0YesVotes)
    expect(voting_history.noes.length).to eq(80)
  end

  it "should get multiple votes with accented individuals" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sampleSessionWithManyVotes)
    expect(voting_history.noes.length).to eq(25)
    expect(voting_history.ayes.length).to eq(51)
  end

  it "should parse accented names correctly" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sessionWithAccents)
    expect(voting_history.ayes[0]).to eq("Roger Hernández")
    expect(voting_history.noes[3]).to eq("Chávez")
  end

end

