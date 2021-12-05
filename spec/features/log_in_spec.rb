require "spec_helper"

def assert_logged_in
  page.has_css?("h1[text='Snapshot']")
end

feature "log in" do
  scenario "valid username and password" do
    visit "/"
    click_on "Log In"
    within ".allysf-login-v1" do
      select "Bank or Invest Login", from: "allysf-login-v1-account"
      fill_in "Username", with: ENV.fetch("WEBSITE_USERNAME")
      fill_in "Password", with: ENV.fetch("WEBSITE_PASSWORD")
      click_on "Log In"
    end
    assert_logged_in
  end
end
