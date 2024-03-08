# frozen_string_literal: true
Given('I am a user with name {string}') do |name|
  name_parts = name.split
  first_name = name_parts.first
  last_name = name_parts[1..].join(' ') # Joins the rest of the parts as the last name.
  email = "#{first_name.downcase}#{last_name.downcase}@tamu.edu"

  @user = FactoryBot.create(:user, first_name: first_name, last_name: last_name, email: email, uid: '123456789')
end

And('I have logged in through the website home page') do
  visit home_path
  click_button "Login with Google"
end

Given('I am on the website user homepage') do
  visit user_path(@user)
end

When('I click on the {string} link') do |string|
  click_link string
end

Then('I should be redirected to the training events page') do
  expect(current_path).to eq(training_activities_path) # assuming your events page is configured at /events
end

Then('I should see a a table of events') do
  expect(page).to have_css('table tbody')
end

Given('I am a verified user') do
  # Have logged in in Background section
end

When('I navigate to the website homepage') do
  visit home_path
end

Then('I should see Howdy {string}!') do |name|
  expect(page).to have_content("Howdy #{name}!")
end

Given('I am using a standard web browser') do
  # This step may not require an actual step definition as it's assumed by using Capybara.
end

When('I visit the website homepage') do
  visit home_path
end

Then('the website should load successfully') do
  expect(page.status_code).to eq(200)
end
