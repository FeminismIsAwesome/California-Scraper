class VotingRecord
  include Mongoid::Document
  belongs_to :legislator
  field :vote, type: String
  field :bill_number, type: String
  field :bill_type, type: String
  field :bill_identity, type: String
  field :year, type: String
  field :date, type: DateTime
  field :voting_location, type: String
  def self.get_votes_for(bills)
  map = %Q{
    function() {
      emit(this.legislator, {count: 1})
    }
  }

  reduce = %Q{
    function(key, values) {
      var result = {count: 0};
      values.forEach(function(value) {
        result.count += value.count;
      });
      return result;
    }
  }

  self.where(:created_at.gt => Date.today, status: "played").
    map_reduce(map, reduce).out(inline: true)
  end
end