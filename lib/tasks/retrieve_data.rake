namespace :retrieve_data do
  desc "retrieves info"
  task get_bill_headers: :environment do
    AssemblyBillHeader.where(:year => "2014").destroy
    CaliforniaWebCrawler.refreshAvailableBillsForYear("2014")
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

  task tally_senator_votes: :environment do
    CaliforniaLegislatureVoteTallier.calculate_all_votes_for("2014")
  end




end
