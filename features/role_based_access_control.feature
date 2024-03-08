Feature: Specific User Access

    As a generic member of the corp of cadets,
    I would expect to be able to have a way of identifying myself to the website,
    So that I can access events that are relevant to me.

Scenario: User login
    Given I am a registered user
    When I visit the login page
    And I enter my username and password
    And I click on the login button
    Then I should be logged into the website
    And my name should be displayed on the top of the homepage

Scenario: Logout
    Given I am logged in
    When I click on the logout link
    Then I should be logged out
    And redirected to the login/hero page

Scenario: Incorrect login credentials
    Given I am on the login page
    When I enter an incorrect username or password
    And I click on the login button
    Then I should see an error message "Incorrect username or password"
    And I should not be logged in
