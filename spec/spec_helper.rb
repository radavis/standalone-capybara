require "capybara/rspec"
require "capybara-screenshot/rspec"
require "webdrivers"
require "pry"
require "rspec"
require_relative "support/authentication_helper"

Capybara.configure do |config|
  config.run_server = false # capybara standalone mode!
  config.default_driver = :selenium_firefox
  config.app_host = ENV.fetch("WEBSITE_URL")
  config.default_max_wait_time = 10
  config.save_path = "./tmp/capybara"
end

# from: https://github.com/teamcapybara/capybara/blob/3.36.0/spec/selenium_spec_firefox.rb
# doesn't work :(
browser_options = ::Selenium::WebDriver::Firefox::Options.new
browser_options.headless! if ENV['HEADLESS']

browser_options.profile = Selenium::WebDriver::Firefox::Profile.new.tap do |profile|
  profile['browser.download.dir'] = Capybara.save_path
  profile['browser.download.folderList'] = 2
  profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv,application/pdf,application/octet-stream,text/csv,text/plain'
  profile['browser.startup.homepage'] = 'about:blank' # workaround bug in Selenium 4 alpha4-7
  profile['accessibility.tabfocus'] = 7 # make tab move over links too
end

Capybara.register_driver :selenium_firefox do |app|
  driver_options = { browser: :firefox, timeout: 31 }.tap do |opts|
    opts[:capabilities] = browser_options
  end
  Capybara::Selenium::Driver.new(app, **driver_options)
end

Capybara::Screenshot.register_driver(Capybara.default_driver) do |driver, path|
  driver.browser.save_screenshot(path)
end

RSpec.configure do |config|
  config.include AuthenticationHelper
end
