class VotingSession
  include Mongoid::Document
  field :ayes, type: Array
  field :noes, type: Array
  field :absent, type: Array
  field :motion, type: String
  field :location, type: String
  field :date, type: DateTime
  field :topic, type: String
  field :author, type: String
  field :yes_voters, type: Array
  field :no_voters, type: Array
  field :absent_voters, type: Array
end