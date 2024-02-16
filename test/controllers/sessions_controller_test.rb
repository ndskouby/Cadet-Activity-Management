require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get logout" do
    get sessions_logout_url
    assert_response :success
  end

  test "should get omniauth" do
    get sessions_omniauth_url
    assert_response :success
  end

  test "should redirect to Google's authentication page" do
    get '/auth/google_oauth2'
    assert_response :redirect
    assert_redirected_to '/auth/google_oauth2/callback'
  end

  test "should authenticate user with Google OAuth and redirect to root" do
    # simulate omniauth authentication
    omniauth.config.test_mode = true
    omniauth.config.mock_auth[:google_oauth2] = omniauth::authhash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: 'user@tamu.edu',
        name: 'User User'
      }
    })

    get '/auth/google_oauth2/callback'
    assert_redirected_to root_url
    assert_equal '123456', session[:user_id]
  end

  test "should handle authentication failure and redirect to login page" do
    # simulate omniauth authentication failure
    omniauth.config.test_mode = true
    omniauth.config.mock_auth[:google_oauth2] = :invalid_credentials

    get '/auth/google_oauth2/callback'
    assert_redirected_to home_url
  end

end
