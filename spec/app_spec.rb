require 'rspec'
require 'capybara'

feature "home page" do
  scenario "says hello world" do
    visit '/'
    expect(page).to have_content("hello world!")
  end
end