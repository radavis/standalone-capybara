class WebsiteTemporarilyUnavailableError < Exception; end

module AuthenticationHelper
  def assert_logged_in
    raise WebsiteTemporarilyUnavailableError if page.title =~ /Temporarily Unavailable/
    find("button", text: "Log Out")
    find("h1", text: "Snapshot") # ensures main content has loaded
  end

  def assert_logged_out
    find("button", text: "Log In")
  end

  def log_in
    visit "/"
    fill_in "Username", with: ENV.fetch("WEBSITE_USERNAME")
    fill_in "Password", with: ENV.fetch("WEBSITE_PASSWORD")
    click_on "Log In"
    assert_logged_in
  end

  def log_out
    click_on "Log Out"
    assert_logged_out
  end
end
