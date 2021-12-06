require "spec_helper"

feature "account automation" do
  scenario "view accounts page", :balances do
    log_in
    screenshot_and_save_page
    log_out
  end

  scenario "view checking account", :activity do
    log_in
    click_on "Checking"
    find("h2", text: "Transaction History")
    screenshot_and_save_page
    log_out
  end

  scenario "download statement", :statement do
    log_in
    click_on "Statements"
    within "ul.statement-list-data" do
      first("a").click
    end
    log_out
  end
end
