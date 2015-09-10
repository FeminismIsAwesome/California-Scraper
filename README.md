California Bill Scraper
== 

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

Getting data onto a new server
== 
There are two ways you can do this currently. 
One is to run all the tasks in order, scraping the legislature data for yourself. To do that run run

```rake retrieve_data:start_new_database_for_2014```

That will take a few minutes. If you're just eager to get the database running yourself, instead you can restore the mongo database from scratch. To do that, take the file at https://drive.google.com/open?id=0Bw9gMxz6LElYNjhYVG1SWjJVSlk and then, after downloading it, unzip the file then do:

```mongorestore dump```


To get the list of bills for a year, run

```rake retrieve_data:get_bill_headers```

To get the voting session history for all the bills in your current database, run

```rake retrieve_data:get_bill_headers```

To get the current list of california assembly members, run
```rake retrieve_data:get_california_assembly_members_current_year```

To get the current list of california senators, run
```rake retrieve_data:get_california_senators```