require "dotenv"
Dotenv.load

require "rspec"
require "capybara/rspec"
require "selenium-webdriver"
require "pry"

Capybara.run_server = false

Capybara.register_driver :custom_chromium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  # user_agent = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0'
  # user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:135.0) Gecko/20100101 Firefox/135.0'
  user_agent ||= ENV["USER_AGENT"]

  # https://chromium.googlesource.com/chromium/src/+/master/chrome/common/chrome_switches.cc
  [
    # "--browser-test",
    # "--start-maximized",
    "--disable-blink-features=AutomationControlled",
    "--disable-component-update",
    "--disable-auto-maximize-for-tests",
    "--disable-background-networking",
    "--disable-crashpad-for-testing",
    "--disable-default-apps",
    "--disable-domain-reliability",
    "--disable-extensions",
    "--disable-default-browser-promo",
    "--disable-login-screen-apps",
    "--ignore-user-profile-mapping-for-tests",
    "--headless",
    "--incognito",
    # "--no-sandbox",
    "--no-default-browser-check",
    "--no-experiments",
    # "--disable-web-security",
    # "--allow-running-insecure-content",
    # "--disable-client-side-phishing-detection",
    "--disable-dev-shm-usage",
    # "--kiosk",
    "--window-size=1440,900",
    "--user-agent=#{user_agent}",
  ].each { |arg| options.add_argument(arg) }

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end
Capybara.javascript_driver = :custom_chromium

Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.default_driver = :custom_chromium # %w[selenium selenium_headless selenium_chrome selenium_headless_chrome]
  config.app_host = ENV["WEBSITE_URL"] || "http://localhost:3000"
end

RSpec.configure do |config|
  config.after do |example|
    if example.exception
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      save_screenshot("./reports/#{timestamp}--screenshot.png")
    end

    # STDERR.puts page.driver.browser.logs.get(:browser) # https://stackoverflow.com/a/49284263/2675670

    # https://bibwild.wordpress.com/2024/10/08/getting-rspec-capybara-browser-console-output-for-failed-tests/
    if example.exception
      browser_logs = page.driver.browser.logs.get(:browser).collect { |log| "#{log.level}: #{log.message}" }

      if browser_logs.any?
        new_exception = example.exception.class.new("#{example.exception.message}\n\nBrowser console:\n\n#{browser_logs.join("\n")}\n")
        new_exception.set_backtrace(example.exception.backtrace)
        example.display_exception = new_exception
      end
    end
  end
end
