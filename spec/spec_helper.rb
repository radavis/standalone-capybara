require "dotenv"
Dotenv.load

require "rspec"
require "capybara/rspec"
require "selenium-webdriver"
require "pry"

Capybara.run_server = false

Capybara.register_driver :custom_chromium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  # user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36'
  # user_agent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
  # user_agent = 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:74.0) Gecko/20100101 Firefox/74.0'
  # user_agent = 'Mozilla/5.0 (Windows; U; Win 9x 4.90; SG; rv:1.9.2.4) Gecko/20101104 Netscape/9.1.0285'
  # user_agent = 'Mozilla/5.0 (PlayStation 4 3.11) AppleWebKit/537.73 (KHTML, like Gecko)'
  user_agent = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0'

  # https://chromium.googlesource.com/chromium/src/+/master/chrome/common/chrome_switches.cc
  [
    # "--browser-test",
    "--start-maximized",
    "--disable-blink-features=AutomationControlled",
    # "--disable-auto-maximize-for-tests",
    # "--disable-background-networking",
    # "--disable-crashpad-for-testing",
    "--headless",
    # "--incognito",
    "--no-sandbox",
    # "--disable-web-security",
    # "--allow-running-insecure-content",
    # "--disable-client-side-phishing-detection",
    "--disable-dev-shm-usage",
    # "--kiosk",
    "--window-size=1536,780",
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
