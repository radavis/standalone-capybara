require "spec_helper"

feature "account automation" do
  scenario "view account page, download latest statement" do
    log_in
    screenshot_and_save_page

    click_on "Statements"

    # statement links have target="_blank" attribute
    window = nil
    within "ul.statement-list-data" do
      window = window_opened_by { first("a").click }
    end

    within_window window do
      screenshot_and_save_page
      puts page.response_headers["Content-Type"]
    end

    log_out
  end
end
