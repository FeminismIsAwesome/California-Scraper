class VotingHistoryScraper
  def self.get_voting_history_for(content)
    content = BillNameScraper.clean_content(content)
    ayes = content.match("AYES.*?*")[0]
  end
end