require "capybara/rspec"
require "capybara-screenshot/rspec"
require "webdrivers"
require "pry"
require "rspec"
require_relative "support/authentication_helper"
# require_relative "support/firefox_driver"

profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.download.dir'] = "/home/rd/projects/ally/downloads"
profile["browser.helperApps.neverAsk.saveToDisk"] = "application/pdf"
options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
# driver = Selenium::WebDriver.for(:firefox, options: options)
Capybara.register_driver(:firefox) do |driver|
  Capybara::Selenium::Driver.new(driver, browser: :firefox, options: options)
end

Capybara::Screenshot.register_driver(:firefox) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.configure do |config|
  config.run_server = false # capybara standalone mode!
  config.default_driver = :selenium_headless
  config.app_host = ENV.fetch("WEBSITE_URL")
  config.default_max_wait_time = 10
end

RSpec.configure do |config|
  config.include AuthenticationHelper
end
