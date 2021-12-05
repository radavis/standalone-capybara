require "spec_helper"

feature "account automation" do
  scenario "download latest statement" do
    log_in
    screenshot_and_save_page

    click_on "Statements"
    screenshot_and_save_page

    within "ul.statement-list-data" do
      first("a").click
    end
    screenshot_and_save_page

    log_out
  end
end
