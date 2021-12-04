require "spec_helper"

feature "search rubygems.org for capybara" do
  scenario "it should find results for capybara" do
    visit "/search/advanced"
    fill_in "Search Gems…", with: "capybara\n"
    expect(page).to have_link("capybara")
  end
end
