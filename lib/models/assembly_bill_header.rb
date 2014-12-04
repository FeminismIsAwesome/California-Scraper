class AssemblyBillHeader
  attr_accessor :billNumber, :billType
  def initialize(billNumber, billType)
    @billNumber = billNumber
    @billType = billType
  end
end