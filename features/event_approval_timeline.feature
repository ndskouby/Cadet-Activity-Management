Feature: Viewing event approval progression & timeline

    As a training officer, unit leader, or upper corps leadership
    So that I can understand where an event is on the approval status
    I want to be able to see a “workflow”

Scenario: Viewing event workflow
    Given that I am on the approvals page
    When I click progression for "Test Event"
    Then I should be on the approval workflow page for "Test Event"
    And I should see timeline for the event lifecycle
    And I should see the "Event Created" date is "3/6/2024"
    And I should see the "Event Approved" date is "3/8/2024"
