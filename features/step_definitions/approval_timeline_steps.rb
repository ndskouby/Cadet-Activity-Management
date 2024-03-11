Given('the status of {string} is {string}') do |event_name, initial_status|
  training_activity = TrainingActivity.find_by(name: event_name)
  
  visit audit_activity_path(training_activity)
  
  click_button("Approve")
  click_button("Approve")

  initial_status_human = I18n.t("training_activity.status.#{initial_status}", default: initial_status)
  expect(page).to have_content("Status: #{initial_status_human}")
end

Then('I should be on the approval workflow page for {string}') do |event_name|
  training_activity = TrainingActivity.find_by(name: event_name)
  expect(current_path).to eq(audit_activity_path(training_activity))
  expect(page).to have_content("History")
end

Then('I should see the {string} date is today\'s date') do |progress_type|
  date = Date.today.strftime("%Y-%m-%d")
  expect(page).to have_content(/#{progress_type}.*?#{date}/)
end

Then('I should not see the {string} date is tomorrow\'s date') do |progress_type|
  today = Date.today
  tomorrow = today +1
  date = tomorrow.strftime("%Y-%m-%d")
  expect(page).to_not have_content(/#{progress_type}.*?#{date}/)
end