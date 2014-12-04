class AssemblyBillHeader
  attr_accessor :billNumber, :billType, :author, :topic, :year
  def initialize(billNumber, billType, author, topic, year)
    @billNumber = billNumber
    @author = author
    @topic = topic
    @year = year
    @billType = billType
  end
end