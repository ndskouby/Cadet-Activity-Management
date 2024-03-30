# frozen_string_literal: true

Given('the user is on the training activities page') do
  visit training_activities_path
end

When('the user clicks the "New Activity" link') do
  click_link 'New Activity'
end

Then('the activity creation form should be displayed') do
  expect(page).to have_css('form#training_activity_form')
end

Given('the user is on the "New Training Activity" page') do
  visit new_training_activity_path
end

When('the user fills in all required fields with event details') do
  fill_in 'Activity Name', with: 'Leadership Seminar'
  fill_in 'Activity Date', with: '2030-12-10'
  choose 'time_ma' # Assuming "MA" is the morning time slot and corresponds to the ID 'time_ma'
  fill_in 'Activity Location', with: 'Auditorium'
  select 'Leaders of Character', from: 'Priority'
  fill_in 'Justification', with: 'Necessary for leadership development'
end

And('the user submits the event creation form') do
  click_button 'Create Training activity'
end

Then('a success message {string} should be displayed') do |message|
  expect(page).to have_content(message)
end

And('the new event should be listed in the "Training Activities" page') do
  visit training_activities_path
  expect(page).to have_content('Leadership Seminar')
end

# Scenario: Attempting to create a new event without filling all required fields
When('the user attempts to submit the event creation form without filling all required fields') do
  fill_in 'Activity Date', with: '2024-03-10' # Only fill out Activity Date
  click_button 'Create Training activity'
end

Then('an error message indicating the missing required fields should be displayed') do
  expect(page).to have_content("Activity Name can't be blank")
  expect(page).to have_content("Time can't be blank")
  expect(page).to have_content('Time is not included in the list')
  expect(page).to have_content("Location can't be blank")
  expect(page).to have_content("Priority can't be blank")
  expect(page).to have_content("Justification can't be blank")
end

When('the user clicks the "Back" link') do
  click_link 'Back' # Ensure the text matches exactly or adjust accordingly
end

Then('the user should be redirected back to the training activities page without creating a new event') do
  expect(current_path).to eq training_activities_path
end
