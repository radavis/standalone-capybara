require "rspec"
require "capybara/rspec"
require "dotenv"
Dotenv.load

Capybara.configure do |config|
  config.default_driver = :selenium
  config.app_host = ENV["WEBSITE_URL"] || "http://localhost:3000"
end
