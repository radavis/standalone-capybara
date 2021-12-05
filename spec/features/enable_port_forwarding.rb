require "spec_helper"

feature "port forwarding" do
  scenario "enable" do
    log_in
    find("div#option4").click() # WAN
    find("span", text: "Virtual Server / Port Forwarding").click
    find("input[name='vts_enable_x'][value='1']").click # "Yes"
    click_on "Apply"
    expect(page).to have_content("Applying Settings...")
  end
end
