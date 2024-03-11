Then('an email should be sent to the {string} unit') do |unit|
 visit 'letter_opener'
 expect(page).to have_text("To: dummy_#{unit}_unit@tamu.edu")
end

Then('an email should not be sent to the {string} unit') do |unit|
    visit 'letter_opener'
    expect(page).to_not have_text("To: dummy_#{unit}_unit@tamu.edu")
   end
