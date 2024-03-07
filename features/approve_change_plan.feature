Feature: Approve or Change training plan 

    As a training officer, unit leader, or upper corps leadership
    So that the event does not count towards the total goal number for that guidance
    I want to confirm/change training plan, which are not yet executed 

Scenario: Confirm training plan event
    Given that I am on the approval details page for "Test Event"
    And that the status of "Test Event" is "Approved"
    When I press the "Confirm" button
    Then the status of "Test Event" should be "Completed"

Scenario: Change trainging plan 
    Given that I am on the approval details page for "Test Event"
    And that the status of "Test Event" is "Approved"
    When I press the "Cancel Event" button
    Then the status of "Test Event" should be "Cancelled"
