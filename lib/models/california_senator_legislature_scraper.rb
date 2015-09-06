class CaliforniaSenatorLegislatureScraper
	@@reference_url = "https://en.wikipedia.org/wiki/California_State_Legislature,_2013%E2%80%9314_session"
	
	def self.get_california_legislators()
		response = RestClient.get @@reference_url
    	html_doc = Nokogiri::HTML(response.body.force_encoding("ISO-8859-1"))
    	senators = get_legislators_from(html_doc.css(".wikitable")[2])
    	assembly = get_legislators_from(html_doc.css(".wikitable")[5])
    	return senators + assembly
	end

	def self.get_legislators_from(source) 
		source.css("tr").map{|row|
    	 columns = row.css("td")
    	 if columns.length > 3
	    	 district = columns[1].text
	    	 name = columns[2].text
	    	 party = columns[3].text
	    	 if columns.length === 6
	    	 	 district = columns[0].text
		    	 name = columns[1].text
		    	 party = columns[2].text
	    	 end
	    	 if(name == "V. Manuel Perez")
	    	 	Legislator.new(first_name: "Victor", last_name: "Perez", middle_name: "Manuel",
	                    party: party, district: district,
	                    house: "Senate", state: "CA")
	    	 else
	    	 	Legislator.new(first_name: name.split(" ").first, last_name: name.split(" ").last,
	                    party: party, district: district,
	                    house: "Senate", state: "CA")
	    	 end
	    	 
	    else
	    	nil
    	 end
    	}.compact
	end

end