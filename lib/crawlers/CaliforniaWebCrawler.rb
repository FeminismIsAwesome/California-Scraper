 require 'net/http'
class CaliforniaWebCrawler
  @@domain_name = "http://www.leginfo.ca.gov/"
  @@bill_index_header = "http://www.leginfo.ca.gov/pub"
  @@bill_index_footer = "bill/index_assembly_bill_author_topic"
  def self.getHistoryFor(bill_header)
    historyUrl = getHistoryLinkGiven(bill_header)
    historyResponse = RestClient.get historyUrl
    beforeAndAfterHistory = historyResponse.split("BILL HISTORY")
    HistoryParser.new().billHistoriesFor(beforeAndAfterHistory[2])
  end


  def self.getHistoryLinkGiven(bill_header)
    query_format = "bill_number=#{bill_header.billType.downcase}_#{bill_header.billNumber}"
    my_query = "http://www.leginfo.ca.gov/cgi-bin/postquery?#{query_format}&sess=PREV"
    response = RestClient.get my_query
    self.parseHistoryFor(response)
  end

  def self.parseHistoryFor(response)
    historyLink = /<a.*History/.match(response.body)[0]
    startOfUrl = "<a href=\""
    endOfUrl = "\"> History"
    historyLink = historyLink[startOfUrl.length..historyLink.length-endOfUrl.length]
    "#{@@domain_name}#{historyLink}"
  end

  def self.refreshAvailableBillsForYear(year)
    url = getFormattedUrlForIndexGiven(year)
    response = RestClient.get url
    billHeaders = BillNameScraper.get_names_given(response.body)
    billHeaders.each do |billHeader|
      billHeader.save!
    end
    puts AssemblyBillHeader.count
  end

  def self.getFormattedUrlForIndexGiven(year)
    priorYear = (year.to_i - 1).to_s
    formatYear = "#{getLastDigitsOfYear(priorYear)}#{"-"}#{getLastDigitsOfYear(year)}"
    url = "#{@@bill_index_header}/#{formatYear}/#{@@bill_index_footer}"
  end

  def self.getLastDigitsOfYear(year)
    year[2..year.length]
  end
end