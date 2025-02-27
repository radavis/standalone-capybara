require "spec_helper"

feature "app" do
  scenario "user signs in, does a remix" do
    visit "/"

    at_marketing_page
    dismiss_cookies_modal
    sign_in_with_google

    at_root_page
    click_first_suggestion
    document_loading
    scroll_down
    document_has_rendered

    click_first_remix_suggestion
    scroll_down
    document_has_rendered
  end
end

def at_marketing_page
  expect(page).to have_current_path("/marketing")
  expect(page).to have_selector("h3", text: /^Create the perfect/i)
end

def at_root_page
  expect(page).to have_current_path("/?mode=auto_mode", wait: 10)
  expect(page).to have_content(/Create Powerful Content/)
end

def dismiss_cookies_modal
  within "#cm" do
    expect(page).to have_content("We use cookies!")
    click_on "Accept all"
  end
end

def click_first_suggestion
  expect(page).to have_selector(".capitol-suggestions__options")

  within ".capitol-suggestions__options" do
    find('.capitol-suggestion', match: :first).click
  end

  within "#remix-sidebar" do
    expect(page).to have_content("your document", wait: 60)
  end
end

def click_first_remix_suggestion
  find('#remix-prompt', match: :first).click  # ambiguous match, lol

  within "#prompt-suggestions-container" do
    find(".capitol-prompt-suggestions__suggestion-item", match: :first).click
  end

  within "#remix-sidebar" do
    expect(page).to_not have_content("Primary Model")
  end
end

def document_has_rendered
  within "#remix-sidebar" do
    expect(page).to have_content("Primary Model", wait: 60)
  end
end

def scroll_down
  sleep 20
  within "#scrollable-story-container" do
    scroll_to :bottom
  end
end

def document_loading
  within "#scrollable-story-container" do
    expect(page).to have_css('div[class^="lottie-loading-block_container__"')
  end
end

def sign_in_with_google
  click_on "Log in"
  click_on "Log in with Google"

  find_field(type: 'email').native.send_keys(ENV["WEBSITE_USERNAME"])
  click_on "Next"

  find_field(type: 'password').native.send_keys(ENV["WEBSITE_PASSWORD"])
  click_on "Next"

  click_on "Continue"
end
