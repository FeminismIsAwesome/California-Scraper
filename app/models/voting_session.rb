class VotingSession
  include Mongoid::Document
  field :ayes, type: Array
  field :noes, type: Array
end