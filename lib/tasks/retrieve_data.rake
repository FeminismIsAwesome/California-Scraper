namespace :retrieve_data do
  desc "retrieves info"
  task get_bill_headers: :environment do
    AssemblyBillHeader.where(:year => "2014").destroy
    CaliforniaWebCrawler.refreshAvailableBillsForYear("2014", "assembly")
  end

  task add_senate_bill_headers: :environment do
    CaliforniaWebCrawler.refreshAvailableBillsForYear("2014", "senate")
  end

  task get_bill_voting_sessions: :environment do
    Bill.all.destroy
    bills = AssemblyBillHeader.all.each do |bill|
      puts "storing bill #{bill.billType}-#{bill.billNumber}"
      CaliforniaWebCrawler.storeVotingHistoriesFor(bill)
      puts "~stored~ #{bill.billType}-#{bill.billNumber}"
    end
end

  task get_california_assembly_members_current_year: :environment do
    CaliforniaAssemblyLegislatureScraper.getCaliforniaAssembly().map {|legislator|
    other = Legislator.where(:first_name => legislator.first_name).where(:last_name => legislator.last_name).where(:middle_name => legislator.middle_name)
    if(other.count == 0)
      legislator.save!
    end
    }
end

  task get_california_senators: :environment do
    CaliforniaSenatorScraper.getCaliforniaSenators().map {|legislator|
      other = Legislator.where(:first_name => legislator.first_name).where(:last_name => legislator.last_name).where(:middle_name => legislator.middle_name)
      if(other.count == 0)
        legislator.save!
      end
    }
  end

  task calculate_voting_relationships_and_store: :environment do
    Legislator.all.each do |legislator|
      if(VotingRecord.where(:legislator => legislator).count === 0)
        puts "now saving for legislator: #{legislator.first_name} #{legislator.last_name}"
        CaliforniaLegislatureVoteTallier.saveVotesFor(legislator)
      end
    end
  end

  task delete_voting_relationships_data: :environment do
    VotingRecord.all.destroy
  end

  task add_district_data: :environment do
    zipCodes = CaliforniaZipCodeCalculator.calculateZipCodesGiven("lib/tasks/Final CD 2013 Zip Codes.csv")
    zipCodes = zipCodes.map{|zipCode|
      zipCode.year = "2014"
      zipCode.save!
    }

  end

end
