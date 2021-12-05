require "capybara/rspec"
require "webdrivers"
require "pry"
require "rspec"

Capybara.configure do |config|
  config.default_driver = :selenium_headless
  config.app_host = ENV["WEBSITE_URL"] || "http://localhost:3000"
end
