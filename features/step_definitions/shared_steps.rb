Given('I am a user with name {string}') do |name|
  name_parts = name.split
  first_name = name_parts.first
  last_name = name_parts[1..].join(' ') # Joins the rest of the parts as the last name.
  email = "#{first_name.downcase}#{last_name.downcase}@tamu.edu"

  @user = User.find_or_create_by(email: email) do |user|
    user.first_name = first_name
    user.last_name = last_name
    user.uid = '123456789'
    user.provider = 'google_oauth2'
  end
end

Given('I have logged in through the website home page') do
  visit home_path
  click_button "Login with Google"
end

Given('I am a logged-in user with name {string}') do |name|
  step "I am a user with name \"#{name}\""
  step "I have logged in through the website home page"
end
