module AuthenticationHelper
  def log_in
    visit "/Main_Login.asp"
    fill_in "Username", with: ENV.fetch("WEBSITE_USERNAME")
    fill_in "Password", with: ENV.fetch("WEBSITE_PASSWORD")
    find("div[onclick='login();']").click
    expect(page).to have_content("Logout")
  end
end
