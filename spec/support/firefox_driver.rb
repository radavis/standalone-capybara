class FirefoxDriver
  SYMBOL = :firefox_driver

  DOWNLOAD_DIR = "downloads"

  # ALLOWED_MIME_TYPES = [
  #   "application/octet-stream",
  #   "application/pdf",
  #   "application/vnd.ms-excel",
  #   "text/csv",
  #   "text/plain",
  # ]

  def initialize
    Capybara.register_driver(SYMBOL) do |driver|
      Capybara::Selenium::Driver.new(driver, browser: :firefox, options: options)
    end
  end

  private

  def options
    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    # options.add_argument("--headless")
    options
  end

  def profile
    # see 'about:config' in Firefox Browser
    # or https://searchfox.org/mozilla-central/source/modules/libpref/init/all.js
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["browser.download.dir"] = download_path
    profile["browser.helperApps.neverAsk.saveToDisk"] = "application/pdf"
    profile
  end

  def mime_types
    ALLOWED_MIME_TYPES.join(",")
  end

  def download_path
    path = File.join(__dir__, "..", "..", DOWNLOAD_DIR)
    pathname = Pathname.new(path).realpath
    pathname.to_s
  end
end

# register the driver on load
# FirefoxDriver.new
