# frozen_string_literal: true

Given('I am a user with name {string}') do |name|
  name_parts = name.split
  first_name = name_parts.first
  last_name = name_parts[1..].join(' ') # Joins the rest of the parts as the last name.
  email = "#{first_name.downcase}#{last_name.downcase}@tamu.edu"

  @commandant = Commandant.find_or_create_by(name: 'Dummy commandant') do |commandant|
    commandant.email = 'dummy_commandant@tamu.edu'
  end
  commandant_id = @commandant.id

  @major_unit = MajorUnit.find_or_create_by(name: 'Dummy major unit') do |major_unit|
    major_unit.email = 'dummy_major_unit@tamu.edu'
    major_unit.commandant_id = commandant_id
  end
  major_id = @major_unit.id

  @minor_unit = MinorUnit.find_or_create_by(name: 'Dummy minor unit') do |minor_unit|
    minor_unit.email = 'dummy_minor_unit@tamu.edu'
    minor_unit.major_unit_id = major_id
  end
  minor_id = @minor_unit.id

  @user = User.find_or_create_by(email:) do |user|
    user.first_name = first_name
    user.last_name = last_name
    user.uid = '123456789'
    user.provider = 'google_oauth2'
    user.minor_unit_id = minor_id
  end
end

Given('I have logged in through the website home page') do
  visit home_path
  click_button 'Login with Google'
end

Given('I am a logged-in user with name {string}') do |name|
  step "I am a user with name \"#{name}\""
  step 'I have logged in through the website home page'
end
