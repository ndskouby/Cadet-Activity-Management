Feature: Approval list

    As a training officer, unit leader, or upper corps leadership
    So that I can remark on events quickly
    I want to be able to see all events that need my attention in order, like a to-do list

Scenario: Accessing the approval page
    Given that I am on the home page
    When I click the "Event Approval" link
    Then I should be on the approvals page

Scenario: Viewing individual events for approval
    Given that I am on the approvals page
    When I click show for "Test Event"
    Then I should be on the approval details page for "Test Event"

Scenario: Approving event
    Given that I am on the approval details page for "Test Event"
    And that the status of "Test Event" is "Pending"
    When I press the "Approve Event" button
    Then the status of "Test Event" should be "Approved"

Scenario: Request improving event
    Given that I am on the approval details page for "Test Event"
    And that the status of "Test Event" is "Pending"
    When I press the "Improve Event" button
    And I enter "Note" into the text box
    Then the status of "Test Event" should be "Needs Revision"

Scenario: Denying event 
    Given that I am on the approval details page for "Test Event"
    And the status of "Test Event" is "Pending"
    When I press the "Deny Event" button
    Then the status of "Test Event" should be "Denied"