 require 'net/http'
class CaliforniaWebCrawler
  @@domain_name = "http://www.leginfo.ca.gov/"
  def self.getHistoryFor(bill_header)
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
    puts "#{@@domain_name}#{historyLink}"
  end
end