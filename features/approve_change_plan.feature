Feature: Approve or Change training plan

  As a training officer, unit leader, or upper corps leadership
  So that the event does not count towards the total goal number for that guidance
  I want to confirm/change training plans, which are not yet executed 

  Background: User is on the Approval Details Page for an Approved "Test Event"
    Given I am a logged-in user with name "John Doe"
    And that I am on the approval details page for "Test Event"
    And that the status of "Test Event 0110" is "approved"

  Scenario: Confirm training plan event
    When I press the "Confirm" button
    Then the status of "Test Event 0110" should be "Completed"

  Scenario: Change training plan
    When I press the "Cancel Event" button
    Then the status of "Test Event 0110" should be "Cancelled"
