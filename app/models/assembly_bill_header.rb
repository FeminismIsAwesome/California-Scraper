class AssemblyBillHeader
  include Mongoid::Document
  attr_accessor :billNumber, :billType
  field :billNumber, type: String
  field :billType, type: String
end