Given('the following training activities exist:') do |table|
  user = User.find_by(first_name: "John", last_name: "Doe")
  user_id = user.id
  table.hashes.each do |row|
    TrainingActivity.create!(name: row['name'], date: Date.parse(row['date']), time: row['time'], location: row['location'], priority: row['priority'], justification: row['justification'], user_id: user_id)
  end
end

Given('that I am on the user homepage') do
  visit user_path(@user)
end

When('I click the {string} link') do |string|
  click_link 'Audit Activities'
end

Then('I should be on the Audit Activities page') do
  expect(page).to have_current_path(audit_activities_path)
end

# Scenario: Viewing individual events for approval
Given('that I am on the Audit Activities page') do
  visit audit_activities_path
end

When('I click show for {string}') do |activity_name|
  activity_row = find('tbody tr', text: activity_name, match: :prefer_exact)
  activity_row.find_link('Show').click
end

Then('I should be on the approval details page for {string}') do |event_name|
  training_activity = TrainingActivity.find_by(name: event_name)
  expect(current_path).to eq(audit_activity_path(training_activity))
  expect(page).to have_content(event_name)
  expect(page).to have_content('Status:')
end

# Scenario: Approving event
Given('that I am on the approval details page for {string}') do |event_name|
  training_activity = TrainingActivity.find_by(name: event_name) || create(:training_activity, name: event_name)
  visit audit_activity_path(training_activity)
end

And('that the status of {string} is {string}') do |event_name, initial_status|
  training_activity = TrainingActivity.find_by(name: event_name) || create(:training_activity, name: event_name, status: initial_status)
  
  visit audit_activity_path(training_activity)
  
  initial_status_human = I18n.t("training_activity.status.#{initial_status}", default: initial_status)
  expect(page).to have_content("Status: #{initial_status_human}")
end

When('I press the {string} button') do |button_text|
  click_button(button_text)
end

Then('the status of {string} should be {string}') do |event_name, new_status|
  training_activity = TrainingActivity.find_by(name: event_name)
  initial_status_human = I18n.t("training_activity.status.#{training_activity.status}")

  training_activity.reload
  expect(training_activity.status).to eq(new_status)
  expect(page).to have_content("Status: #{initial_status_human}")
end

Then('the status of {string} should not be {string}') do |event_name, new_status|
  training_activity = TrainingActivity.find_by(name: event_name)
  initial_status_human = I18n.t("training_activity.status.#{training_activity.status}")

  training_activity.reload
  expect(training_activity.status).to_not eq(new_status)
  expect(page).to have_content("Status: #{initial_status_human}")
end

