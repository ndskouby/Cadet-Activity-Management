Feature: Accessible Website for Corps of Cadets

As a user
I want to be able to access the website from my browser,
So that I can view upcoming events and plan new ones.

Scenario: Viewing the events page
    	Given I am on the website homepage
    	When I click on the "Events" link
    	Then I should be redirected to the events page
    	And I should see a list of events

Scenario: Accessing the homepage
    	Given I am a verified user
    	When I navigate to the website homepage
    	Then I should see the homepage content

Scenario: Checking website accessibility on a standard web browser
    	Given I am using a standard web browser
    	When I visit the website homepage
    	Then the website should load successfully