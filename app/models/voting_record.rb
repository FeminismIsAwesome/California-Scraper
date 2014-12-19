class VotingRecord
  include Mongoid::Document
  belongs_to :legislator
  field :vote, type: String
  field :bill_number, type: String
  field :bill_type, type: String
end