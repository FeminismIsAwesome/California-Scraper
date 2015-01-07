class Bill
  include Mongoid::Document
  field :billNumber, type: String
  field :billType, type: String
  field :bill_url, type: String
  embeds_many :votingSessions
  field :year

  def formatted_bill_header
    "#{billType}-#{billNumber}"
  end

end
