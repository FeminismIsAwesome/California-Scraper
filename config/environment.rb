# Load the Rails application.
Dir['./lib/models/*.rb'].each { |f| require(f) }
Dir['./lib/crawlers/*.rb'].each { |f| require(f) }
require File.expand_path('../application', __FILE__)
# Initialize the Rails application.
Rails.application.initialize!
