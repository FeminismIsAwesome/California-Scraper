class BillNameScraper
  def self.get_names_given(content)
    valid_string = content.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    eachLineRegex = /^[a-z]*\s[0-9]*/i
    names = valid_string.scan(eachLineRegex)
    assemblyBills = names.map do |name|
      billType = /^[A-Z]*/.match(name)[0]
      billNumber = /[0-9]*$/i.match(name)[0]
      if (billNumber != "")
        AssemblyBillHeader.new(billNumber, billType)
      else
        nil
      end
    end
    assemblyBills.select{|name| name != nil }
  end

end