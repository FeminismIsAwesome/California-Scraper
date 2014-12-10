class BillNameScraper
  def self.get_names_given(content)
    valid_string = clean_content(content)
    eachLineRegex = /^[a-z]*\s[0-9]*/i
    names = valid_string.scan(eachLineRegex)
    assemblyBills = names.map do |name|
      billType = /^[A-Z]*/.match(name)[0]
      billNumber = /[0-9]*$/i.match(name)[0]
      if (billNumber != "")
        AssemblyBillHeader.new(billNumber: billNumber.to_s, billType: billType.to_s)
      else
        nil
      end
    end
    assemblyBills.select{|name| name != nil }
  end

  def self.clean_content(content)
    content.scrub("")
  end

  def self.get_votes_given(content)
    content = self.clean_content(content)
    voteContent = /Votes.*/m.match(content)[0]
    votes = voteContent.scan(/href=\".*html"/)
    extract_url(votes)
  end



  def self.extract_url(votes)
    votes.map { |vote|
      vote["href=\"".length..vote.length-2]
    }
  end



end