== California Bill Scraper

[![Build Status](https://snap-ci.com/FeminismIsAwesome/California-Scraper/branch/master/build_image)](https://snap-ci.com/FeminismIsAwesome/California-Scraper/branch/master)

This is a scraper and API hoster for california's bill site, aka http://www.leginfo.ca.gov/.

The goal is to eventually be able to pull:

* Bills by id and author

* Voting history of a given legislator

* Easily accessible API for other people to use

Details of implemention

* Ruby 2.2, Rails 4

* Mongo database

* Rspec

* Rake tasks to glob new data into the server

* Hosted on Heroku for API access, but you can just clone the repo if you want to grab the data yourself (or need a faster API)

== Getting data onto a new server

To get the list of bills for a year, run

rake retrieve_data:get_bill_headers


To get the voting session history for all the bills in your current database, run

rake retrieve_data:get_bill_headers

To get the current list of california assembly members, run
rake retrieve_data:get_california_assembly_members_current_year

To get the current list of california senators, run
rake retrieve_data:get_california_senators