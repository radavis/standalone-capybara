require "spec_helper"

feature "search rubygems.org for capybara" do
  scenario "it should find results for capybara" do
    visit "/"
    fill_in "query", with: "capybara"
    click_button "search_submit"

    expect(page).to have_content("capybara")
  end
end
