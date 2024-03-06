Feature: Adding new events

	As a training officer, unit leader, or upper corps leadership
	So that I can plan new events
	I want to be able to create new events

Scenario: Accessing the event creation page
	Given the user is on the homepage
	When the user navigates to the "Create New Event" section
	Then the event creation form should be displayed

Scenario: Creating a new event with all required details
	Given the user is on the "Create New Event" page
	When the user fills in all required fields with event details
	And the user submits the event creation form
	Then a success message "Event successfully created" should be displayed
	And the new event should be listed in the upcoming events

Scenario: Attempting to create a new event without filling all required fields
	Given the user is on the "Create New Event" page
	When the user attempts to submit the event creation form without filling all required fields
	Then an error message indicating the missing required fields should be displayed

Scenario: Cancelling the event creation process
	Given the user is on the "Create New Event" page
   	When the user clicks the "Cancel" button
	Then the user should be redirected back to the homepage without creating a new event
