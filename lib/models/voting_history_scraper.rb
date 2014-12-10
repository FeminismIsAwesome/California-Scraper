#encoding: ISO-8859-1
Encoding.default_external = "ISO-8859-1"
Encoding.default_internal = "ISO-8859-1"
class VotingHistoryScraper
  def self.get_voting_history_for(content)
    ayes = getAyesFor(content)
    noes = getNoesFor(content)
    author = getAuthorFor(content)
    topic = getTopicFor(content)
    date = getDateFor(content)
    location = getLocationFor(content)
    motion = getMotionFor(content)
    VotingSession.new(ayes: ayes, noes: noes,
        author: author, topic: topic, date: date, location: location, motion: motion)
  end

  def self.getMotionFor(content)
    motion = content.match(/MOTION:.*/i)[0]
    motion["MOTION:".length..motion.length].strip
  end

  def self.getLocationFor(content)
    location = content.match(/LOCATION:.*/)[0]
    location["LOCATION:".length..location.length].strip
  end

  def self.getDateFor(content)
    date = content.match(/DATE:.*/)[0]
    date = date["DATE:".length..date.length].strip
    Date.strptime(date, "%m/%d/%Y")
  end

  def self.getTopicFor(content)
    topic = content.match(/Topic:.*/i)[0]
    topic["TOPIC:".length..topic.length].strip
  end

  def self.getAuthorFor(content)
    author = content.match(/Author:.*/i)[0]
    author["Author:".length..author.length].strip
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