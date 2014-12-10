#encoding: ISO-8859-1
Encoding.default_external = "ISO-8859-1"
Encoding.default_internal = "ISO-8859-1"
class VotingHistoryScraper
  def self.get_voting_history_for(content)
    ayes = getAyesFor(content)
    noes = getNoesFor(content)
    VotingSession.new(ayes: ayes, noes: noes)
  end

  def self.getNoesFor(content)
    noes = content.match(/NOES\n\t.*?\*.*ABSENT/m)[0]
    noes = noes["NOES".length..noes.length - " ABSENT".length]
    get_names_of_votes_given(noes)
  end

  def self.getAyesFor(content)
    ayes = content.match(/AYES\n\t.*?\*.*NOES/m)[0]
    ayes = ayes["AYES".length..ayes.length-" NOES".length]
    get_names_of_votes_given(ayes)
  end

  def self.get_names_of_votes_given(namesText)
    namesText.split("\n").map { |nameLine|
      if (nameLine.match(/[A-z][A-z]*/))
        nameLine.split("\t")
      else
        []
      end
    }.select { |name|
      !name.nil?
    }.reduce(:+)
  end
end