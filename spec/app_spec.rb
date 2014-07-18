require 'rspec'
require 'capybara'

feature "home page" do
  scenario "says Howdy" do
    visit '/'
    expect(page).to have_content("Howdy Doody")
  end
end