#encoding: ISO-8859-1

class Bill
  include Mongoid::Document
  field :billNumber, type: String
  field :billType, type: String
  embeds_many :votingSessions
  field :year

end
