#encoding: ISO-8859-1

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
end