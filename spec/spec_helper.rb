require "capybara/rspec"
require "capybara/poltergeist"
require "dotenv"
Dotenv.load
require "pry"
require "rspec"

Capybara.configure do |config|
  config.default_driver = :poltergeist
  config.app_host = ENV["BASE_URL"] || "http://localhost:3000"
end
