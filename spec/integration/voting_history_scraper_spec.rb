#encoding: ISO-8859-1
require "rails_helper"

RSpec.describe "voting history scraper", :type => :model do

  noNoVotesFile = File.open("spec/integration/examples/voting_history_example.html")
  noYesVotesFile = File.open("spec/integration/examples/no_yes_votes_session.html")
  manyVotesFile = File.open("spec/integration/examples/many_votes_with_accents.html")
  sessionWithAccentsFile = File.open("spec/integration/examples/few_votes_with_accents.html")
  absentVotesSenateFile = File.open("spec/integration/examples/absent_senate_vote.html")
  absentVotesAssemblyFile = File.open("spec/integration/examples/absent_assembly_vote.html")

  sampleHistoryWith0NoVotes = noNoVotesFile.read
  sampleHistoryWith0YesVotes = noYesVotesFile.read
  sampleSessionWithManyVotes = manyVotesFile.read
  sessionWithAccents = sessionWithAccentsFile.read
  absentVotesSenate = absentVotesSenateFile.read
  absentVotesAssembly = absentVotesAssemblyFile.read

  it "should get voting noes history as noes when none exist" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sampleHistoryWith0NoVotes)
    expect(voting_history.noes.length).to eq(0)
  end

  it "should get voting absent history if a senate vote" do
    voting_history = VotingHistoryScraper.get_voting_history_for(absentVotesSenate)
    expect(voting_history.absent.length).to eq(8)
  end

  it "should get voting absent history if an assembly vote" do
    voting_history = VotingHistoryScraper.get_voting_history_for(absentVotesAssembly)
    expect(voting_history.absent.length).to eq(1)
  end

  it "should get voting absent history if an assembly vote" do
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

  it "should get voting absent history" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sampleHistoryWith0NoVotes)
    expect(voting_history.absent.length).to eq(1)
    expect(voting_history.absent[0]).to eq("Quirk")
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
    expect(voting_history.ayes[0]).to eq("Roger Hern�ndez")
    expect(voting_history.noes[3]).to eq("Ch�vez")
  end

  it "should get the voting session's date" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sessionWithAccents)
    expect(voting_history.date.year).to eq(2013)
    expect(voting_history.date.month).to eq(4)
    expect(voting_history.date.day).to eq(25)
  end

  it "should get the details of bill" do
    voting_history = VotingHistoryScraper.get_voting_history_for(sessionWithAccents)
    expect(voting_history.author).to eq("Hernandez")
    expect(voting_history.topic).to eq("Health care coverage.")
    expect(voting_history.location).to eq("ASM. FLOOR")
    expect(voting_history.motion).to eq("SB2 Hernandez  Senate Third Reading  By PAN  First Extraordinary")
  end
end

