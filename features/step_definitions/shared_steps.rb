# frozen_string_literal: true

Given('I am a user with name {string}') do |name|
  name_parts = name.split
  first_name = name_parts.first
  last_name = name_parts[1..].join(' ') # Joins the rest of the parts as the last name.
  email = "#{first_name.downcase}#{last_name.downcase}@tamu.edu"

  major = Unit.create(name: 'Demo Major', cat: 'major', email: 'dummy_major_unit@tamu.edu')
  minor = Unit.create(name: 'Demo Minor', cat: 'minor', email: 'dummy_minor_unit@tamu.edu', parent: major)
  outfit = Unit.create(name: 'Demo Outfit', cat: 'outfit', email: 'dummy_outfit_unit@tamu.edu', parent: minor)

  @user = User.find_or_create_by(email:) do |user|
    user.first_name = first_name
    user.last_name = last_name
    user.uid = '123456789'
    user.provider = 'google_oauth2'
    user.unit = outfit
    user.admin_flag = false
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
