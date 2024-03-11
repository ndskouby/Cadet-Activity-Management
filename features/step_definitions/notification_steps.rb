Then('an email should be sent to {string}') do |email|
  visit 'letter_opener'
  expect(page).to have_text("To: #{email}")
end

Then('an email should not be sent to {string}') do |email|
  visit 'letter_opener'
  expect(page).to_not have_text("To: #{email}")
end
