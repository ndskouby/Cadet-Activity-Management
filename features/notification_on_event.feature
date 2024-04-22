Feature: Notification on attention needed

    As a training officer, unit leader, or upper corps leadership
    So that I can know when my attention is needed for an event
    I want to receive an email

Background:
	Given I am a logged-in user with name "John Doe"

Scenario: Send email when creating a new event with all required details
	Given the user is on the "New Training Activity" page
	When the user fills in all required fields with event details
	And the user submits the event creation form
	Then an email should be sent to "testminor@tamu.edu"


Scenario: Creation email not sent to major unit
    Given the user is on the "New Training Activity" page
	When the user fills in all required fields with event details
	And the user submits the event creation form
    Then an email should not be sent to "dummy_major_unit@tamu.edu"

