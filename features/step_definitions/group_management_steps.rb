# frozen_string_literal: true

Then('I should see a list of groups that I am in') do
  expect(page).to have_text('outfit: Demo Outfit')
  expect(page).to have_text('minor: Demo Minor')
  expect(page).to have_text('major: Demo Major')
end
