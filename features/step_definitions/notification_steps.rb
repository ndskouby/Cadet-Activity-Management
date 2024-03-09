Then('an email should be sent to the minor unit') do
 visit 'letter_opener'
 expect(page).to have_text('To: dummy_minor_unit@tamu.edu')
end
