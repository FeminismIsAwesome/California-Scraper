class BillNameScraper
  def self.get_names_given(content)
    valid_string = content.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    eachLineRegex = /[a-z]*\s[0-9]*\s+.*\./i
    names = valid_string.scan(eachLineRegex)
    names.map do |name|
      billType = /^[A-Z]*/.match(name)[0]
      billNumber = /\s[0-9]*\s/.match(name)[0].strip
      if (billNumber != "")
        AssemblyBillHeader.new(billNumber, billType, "Daly", "topic", "2014")
      else
        nil
      end
    end.select {|name| name != nil}
  end

end