require 'rspec'
require 'capybara'

feature "home page" do
  scenario "has content" do
    visit '/'
    expect(page).to have_title("Message")
    expect(page).to have_content("Message Roullete")
  end

  scenario "as a user, I can submit a message" do
    visit '/'

    expect(page).to have_content("Message:")
    fill_in "message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit '/'

    expect(page).to have_content("Message:")
    fill_in "message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Error: restrict your message to only 140 characters.")
  end
end