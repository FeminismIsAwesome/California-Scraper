class CaliforniaSenatorScraper
  @@senate_reference_url = "http://senate.ca.gov/senators"
  def self.getCaliforniaSenators
    response = RestClient.get @@senate_reference_url
    html_doc = Nokogiri::HTML(response.body)
    rows = html_doc.css(".views-row")
    rows.map {|row|
      name = row.css(".views-field-field-senator-last-name h3")
      unless name.text.include?("Vacant")
        details = parse_name_and_party_from(name.text)
        details[:state] = "CA"
        details[:house] = "Senator"
        details[:district] = row.css(".views-field-field-senator-district").text.strip
        details[:email] = row.css(".views-field-field-senator-feedbackurl a").first[:href]
        details[:capital_phone] = row.css(".views-field-field-senator-capitol-office p").text.match(/\(\d\d\d\) \d\d\d-\d\d\d\d/)[0]
        Legislator.new(details)
      else
        nil
      end
    }.select {|row|
      row.present?
    }
  end

  def self.parse_name_and_party_from text
    space_seperated = text.split(" ")
    first_name = space_seperated[0]
    last_name = space_seperated[1]
    middle_name = nil
    party_affiliation = space_seperated[2]
    if has_middle_name(space_seperated)
      middle_name = space_seperated[1]
      last_name = space_seperated[2]
      party_affiliation = space_seperated[3]
    end
    party_affiliation = cleanup_party(party_affiliation)
    senator = Hash.new
    senator[:first_name] = first_name
    senator[:last_name] = last_name
    senator[:party] = party_affiliation
    senator[:middle_name] = middle_name
    senator
  end

  @@parties = {"R" => "Rep", "D" => "Dem"}

  def self.cleanup_party(party_affiliation)
    party = party_affiliation.gsub("(", "").gsub(")", "")
    @@parties[party]
  end

  def self.has_middle_name(space_seperated_text)
    space_seperated_text.length == 4
  end
end