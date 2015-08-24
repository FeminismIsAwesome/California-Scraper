class ZipCode
	  include Mongoid::Document
	  field :zipCode, type: String
	  field :zipCodeName, type: String
	  field :districtCode, type: String
	  field :year, type: String
end