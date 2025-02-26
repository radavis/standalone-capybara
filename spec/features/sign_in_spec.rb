require "spec_helper"

feature "sign in" do
  scenario "user signs in, does a remix" do
    visit "/"

    expect(page).to have_current_path("/marketing")
    expect(page).to have_selector("h3", text: /^Create the perfect/i)

    within "#cm" do
      expect(page).to have_content("We use cookies!")
      click_on "Accept all"
    end

    click_on "Log in"
    click_on "Log in with Google"

    find_field(type: 'email').native.send_keys(ENV["WEBSITE_USERNAME"])
    click_on "Next"

    find_field(type: 'password').native.send_keys(ENV["WEBSITE_PASSWORD"])
    click_on "Next"

    click_on "Continue"

    expect(page).to have_current_path("/?mode=auto_mode")
    expect(page).to have_content(/Create Powerful Content/)

    expect(page).to have_selector(".capitol-suggestions__options")

    within ".capitol-suggestions__options" do
      find('.capitol-suggestion', match: :first).click
    end

    find('#remix-prompt', wait: 120, match: :first).click  # ambiguous match, lol
    within "#prompt-suggestions-container" do
      find(".capitol-prompt-suggestions__suggestion-item", match: :first).click
    end

    within "#remix-sidebar" do
      expect(page).to have_content("Primary Model")
    end

    sleep 500

  end
end
