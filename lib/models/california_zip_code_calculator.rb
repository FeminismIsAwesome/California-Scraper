require 'csv'

class CaliforniaZipCodeCalculator
	def self.calculateZipCodesGiven(fileContents)
		zipCodes = CSV.read(fileContents, :headers => true)
		zipCodes.map {|zipCodeContent|
			zip = ZipCode.new;
			zip.districtCode = zipCodeContent["2013 Congressional Districts"]
			zip.zipCode = zipCodeContent["Zip Code"]
			zip.zipCodeName = zipCodeContent["Zip Code Name"]
			zip
		}

	end
end