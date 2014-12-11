require 'open-uri'
class CaliforniaAssemblyLegislatureScraper
  @@assembly_reference_url = "http://clerk.assembly.ca.gov//clerk/memberinformation/memberdir_1.asp"

  def self.getCaliforniaAssembly
    response = RestClient.get @@assembly_reference_url
    html_doc = Nokogiri::HTML(response.body.force_encoding("ISO-8859-1"))
    html_doc.css("tr:nth-child(n+3)").map {|row|
      columns_of_row = row.css("td")
      member_name = split_name(columns_of_row[0].text)
      first_name = get_first_name_from(member_name)
      middle_name = get_middle_name_from(member_name)
      last_name = get_last_name_from(member_name)
      party = clean_text(columns_of_row[1].text)
      district = clean_text(columns_of_row[2].text)
      capital_phone = clean_text(columns_of_row[3].text)
      room_number = clean_text(columns_of_row[4].text)
      email = extract_email(columns_of_row)
      Legislator.new(first_name: first_name, middle_name: middle_name, last_name: last_name,
                    party: party, district: district, capital_phone: capital_phone, room_number: room_number, email: email,
                    house: "Assembly", state: "CA")
    }

  end

  def self.extract_email(columns_of_row)
    possible_email = columns_of_row[5].css("a")[0]['href']
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
    member_name.split(" ").map {|name|
      name.gsub(",","")
    }
  end

  def self.get_first_name_from(member_name)
     member_name[1]
  end
end