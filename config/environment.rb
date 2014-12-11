#encoding: ISO-8859-1

# Load the Rails application.
Dir['./lib/models/*.rb'].each { |f| require(f) }
Dir['./lib/crawlers/*.rb'].each { |f| require(f) }
require File.expand_path('../application', __FILE__)
Encoding.default_external = "ISO-8859-1"
Encoding.default_internal = "ISO-8859-1"
# Initialize the Rails application.
Rails.application.initialize!
