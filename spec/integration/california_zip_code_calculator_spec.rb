require "rails_helper"

RSpec.describe CaliforniaZipCodeCalculator, :type => :model do
	it "should calculate zip codes" do
		fileName = "spec/integration/examples/Final CD 2013 Zip Codes.csv"
		zipCodesPerDistrict = CaliforniaZipCodeCalculator.calculateZipCodesGiven(fileName)
		expect(zipCodesPerDistrict.length).to eq(3605)
	end
end