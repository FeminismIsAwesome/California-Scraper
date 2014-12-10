class VotingSession
  include Mongoid::Document
  field :billNumber, type: String
  field :billType, type: String
  field :year, type: String
end