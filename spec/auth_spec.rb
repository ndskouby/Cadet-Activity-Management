# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User Authentication', type: :feature do
  # Create a mock login credential
  let(:mock_auth_hash) do
    OmniAuth::AuthHash.new({
                             provider: 'google_oauth2',
                             uid: '2024',
                             info: {
                               email: 'user@tamu.edu',
                               name: 'John Doe'
                             }
                           })
  end

  before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = mock_auth_hash
    visit home_path
    click_button 'Login with Google'
  end

  after(:each) do
    click_link 'Logout'
  end

  scenario 'user/ page renders properly after successful login' do
    expect(page).to have_content('Email: user@tamu.edu')
    expect(page).to have_content('Howdy John!')
    expect(page).to have_content('First name: John')
    expect(page).to have_content('Last name: Doe')
  end

  scenario 'Session created successfully and updated in the users table' do
    expect(User.count).to eq(1)
    expect(User.first.email).to eq('user@tamu.edu')
  end

  scenario 'Visiting after logging out should still have session active' do
    visit home_path
    expect(page).to have_content('Logout')
    # Check if the user_id matches database value
    expect(User.where(uid: 2024).first.email).to eq('user@tamu.edu')
  end
end

RSpec.feature 'Invalid Authentication', type: :feature do
  scenario 'Accessing user page through url without logging in should throw an error' do
    visit '/users/12'
    expect(page).to have_current_path('/home/index')
    expect(page).to have_content('You must be logged in to access this section.')
  end

  scenario 'Recieves invalid user credentials and does not log in' do
    allow_any_instance_of(User).to receive(:valid?).and_return(false)

    visit '/auth/google_oauth2/callback'

    # Expect to be redirected to home page
    expect(page).to have_current_path(home_path)
    expect(page).to have_content('Login failed.')
  end
end
