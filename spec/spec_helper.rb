require "capybara/rspec"
require "capybara-screenshot/rspec"
require "webdrivers"
require "pry"
require "rspec"
require_relative "support/authentication_helper"

Capybara.configure do |config|
  config.run_server = false # capybara standalone mode!
  config.default_driver = :selenium_chrome
  config.app_host = ENV.fetch("WEBSITE_URL")
  config.default_max_wait_time = 10
  config.save_path = "./downloads"
end

browser_options = ::Selenium::WebDriver::Chrome::Options.new
browser_options.headless! if ENV['HEADLESS']

Capybara.register_driver :selenium_chrome do |app|
  version = Capybara::Selenium::Driver.load_selenium
  driver_options = { browser: :chrome, timeout: 30 }.tap do |opts|
    opts[:capabilities] = browser_options
  end

  Capybara::Selenium::Driver.new(app, **driver_options).tap do |driver|
    driver.browser.download_path = Capybara.save_path
  end
end

Capybara::Screenshot.register_driver(Capybara.default_driver) do |driver, path|
  driver.browser.save_screenshot(path)
end

RSpec.configure do |config|
  config.include AuthenticationHelper
end
