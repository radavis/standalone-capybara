require "capybara/rspec"
require "webdrivers"
require "pry"
require "rspec"
require_relative "support/authentication_helper"

Capybara.configure do |config|
  config.default_driver = :selenium
  config.app_host = ENV.fetch("WEBSITE_URL")
end

RSpec.configure do |config|
  config.include AuthenticationHelper
end
