Feature: Viewing event approval progression & timeline

    As a training officer, unit leader, or upper corps leadership
    So that I can understand where an event is on the approval status
    I want to be able to see a “workflow”

Background:
	Given I am a logged-in user with name "John Doe"
    Given the following training activities exist:
      | name            |unit| date       | time | location    | priority | justification        |
      | Leadership 101  |Demo Outfit| 2024-05-20 | MA   | Hall A      | Leaders of Character     | Leadership skills    |
      | Safety Training |Demo Outfit| 2024-06-15 | AA   | Outdoor     | Career Readiness   | Safety precautions   |
    Given the status of "Leadership 101" is "pending_commandant_approval"

Scenario: Viewing event workflow
    Given that I am on the approval details page for "Leadership 101"
    Then I should be on the approval workflow page for "Leadership 101"
    And I should see the "Major Unit Approval" date is today's date
    And I should see the "Minor Unit Approval" date is today's date

Scenario: Viewing incorrect dates for event workflow
    Given that I am on the approval details page for "Leadership 101"
    Then I should be on the approval workflow page for "Leadership 101"
    And I should not see the "Major Unit Approval" date is tomorrow's date
    And I should not see the "Minor Unit Approval" date is tomorrow's date
    
