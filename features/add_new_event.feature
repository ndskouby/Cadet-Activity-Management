Feature: Adding new events

	As a training officer, unit leader, or upper corps leadership
	So that I can plan new events
	I want to be able to create new events

Background:
	Given I am a logged-in user with name "John Doe"

Scenario: Accessing the event creation page
	Given the user is on the training activities page
	When the user clicks the "New Activity" link
	Then the activity creation form should be displayed

Scenario: Creating a new event with all required details
	Given the user is on the "New Training Activity" page
	When the user fills in all required fields with event details
	And the user submits the event creation form
	Then a success message "Training Activity was successfully created." should be displayed
	And the new event should be listed in the "Training Activities" page

Scenario: Attempting to create a new event without filling all required fields
	Given the user is on the "New Training Activity" page
	When the user attempts to submit the event creation form without filling all required fields
	Then an error message indicating the missing required fields should be displayed

Scenario: Cancelling the event creation process
	Given the user is on the "New Training Activity" page
   	When the user clicks the "Back" link
	Then the user should be redirected back to the training activities page without creating a new event
