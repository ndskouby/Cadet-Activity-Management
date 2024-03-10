Feature: Notification on attention needed

    As a training officer, unit leader, or upper corps leadership
    So that I can know when my attention is needed for an event
    I want to receive an email

Background:
	Given I am a logged-in user with name "John Doe"

Scenario: Creating a new event with all required details
	Given the user is on the "New Training Activity" page
	When the user fills in all required fields with event details
	And the user submits the event creation form
	Then an email should be sent to the minor unit


Scenario: Send email on lower approval
    Given that I am on the approval details page for "Test Event"
    And that the status of "Test Event" is "pending_minor_unit_approval"
    When I press the "Approve" button
    Then the status of "Test Event" should be "pending_major_unit_approval"
    And an email should be sent to the next approving officer
