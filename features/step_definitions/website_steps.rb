
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
