Feature: Notification on attention needed

    As a training officer, unit leader, or upper corps leadership
    So that I can know when my attention is needed for an event
    I want to receive an email

Scenario: Send email on lower approval 
    Given that I am on the approval details page for "Test Event"
    And that the status of "Test Event" is "Pending 1st approval"
    When I press the "Approve Event" button
    Then the status of "Test Event" should be "Pending 2nd approval"
    And an email should be sent to the next approving officer
