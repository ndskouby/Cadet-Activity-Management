Feature: Calendar for the Events
    As a training officer, unit leader, or upper corps leadership
    So that I can see all approved activities planned by a certain unit on the calendar.
    And I can see activities on a certain date when I click.

Background:
	Given I am a logged-in user with name "John Doe"
    Given the following training activities exist:
      | name            | date       | time | location    | priority | justification        |
      | Leadership 101  | 2024-05-20 | MA   | Hall A      | Leaders of Character     | Leadership skills    |
      | Safety Training | 2024-06-15 | AA   | Outdoor     | Career Readiness   | Safety precautions   |
    Given the status of "Leadership 101" is "pending_commandant_approval"

Scenario: Viewing the statistical charts page
	Given I am on the website user homepage
	When I click on the "Training Activities" link
    Then I should see a "Leadership 101" in the calendar

Scenario: Viewing the statistical charts page
	Given I am on the website user homepage
	When I click on the "Training Activities" link
    Then I should not see any unlisted event in the calendar


