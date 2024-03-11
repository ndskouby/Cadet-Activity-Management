Feature: Accessible Website for Corps of Cadets

	As a user
	I want to be able to access the website from my browser,
	So that I can view upcoming events and plan new ones.

Background:
	Given I am a logged-in user with name "John Doe"

Scenario: Viewing the events page
	Given I am on the website user homepage
	When I click on the "Training Activities" link
	Then I should be redirected to the training events page
	And I should see a a table of events

Scenario: Accessing the user homepage
	Given I am a verified user
	When I navigate to the website homepage
	Then I should see Howdy "John"!

Scenario: Checking website accessibility on a standard web browser
	Given I am using a standard web browser
	When I visit the website homepage
	Then the website should load successfully