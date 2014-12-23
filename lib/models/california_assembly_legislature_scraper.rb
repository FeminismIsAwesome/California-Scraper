require 'open-uri'
class CaliforniaAssemblyLegislatureScraper
  @@assembly_reference_url = "http://clerk.assembly.ca.gov//clerk/memberinformation/memberdir_1.asp"

  def self.getCaliforniaAssembly
    response = RestClient.get @@assembly_reference_url
    html_doc = Nokogiri::HTML(response.body.force_encoding("ISO-8859-1"))
    html_doc.css("table tbody tr").map {|row|
      columns_of_row = row.css("td")
      member_row = row.css(".views-field-field-member-lname-value-1")
      district_row = row.css(".views-field-field-member-district-value")
      party_row = row.css(".views-field-field-member-party-value")
      feedback_row = row.css(".views-field-field-member-feedbackurl-value")
      member_name = split_name(member_row.text)
      first_name = get_first_name_from(member_name)
      middle_name = get_middle_name_from(member_name)
      last_name = get_last_name_from(member_name)
      party = clean_text(party_row.text)
      district = clean_text(district_row.text)
      capital_phone = extract_phone_number_from(feedback_row, 0)
      room_number = feedback_row.css("p")[0].text.gsub("\n","").strip
      email = extract_email(feedback_row)
      Legislator.new(first_name: first_name, middle_name: middle_name, last_name: last_name,
                    party: party, district: district, capital_phone: capital_phone, room_number: room_number, email: email,
                    house: "Assembly", state: "CA")
    }

  end

  def self.extract_phone_number_from(feedback_row, index)
    contact_text = feedback_row.css("p")[index].text
    phoneRegex = /\(\d\d\d\) \d\d\d-\d\d\d\d/m
    if contact_text.match(phoneRegex)
      contact_text.match(phoneRegex)[0]
    else
      puts contact_text
    end
  end

  def self.extract_email(email_row)
    possible_email = email_row.css("a")[0]['href']
    if(possible_email.match(/javascript/))
      possible_email.match(/'http.*?'/)[0].gsub("'","").strip
    else
      possible_email
    end
  end

  def self.clean_text(text)
    text.gsub("\n","").strip
  end

  def self.get_last_name_from(member_name)
    member_name[0]
  end

  def self.get_middle_name_from(member_name)
    if member_name.length > 2
      member_name[2]
    else
      nil
    end
  end

  def self.split_name(member_name)
    names = member_name.gsub("\n","").strip.split(",")
    secondHalfOfName = names[1].strip.split(" ")
    if secondHalfOfName.length > 2
      [names[0].strip, secondHalfOfName[0].strip, secondHalfOfName[1].strip]
    else
      [names[0].strip, names[1].strip]
    end
  end

  def self.get_first_name_from(member_name)
     member_name[1]
  end
end