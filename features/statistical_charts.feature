Feature: Statistical Charts for the Events

As a training officer, unit leader, or upper corps leadership
So that I can view the status and completion of the CMDTS goals that a unit is supposed to achieve.
I want to be able to see the bar graph and sheet of completion time and training type for a certain unit.


Background:
	Given I am a logged-in user with name "John Doe"
    Given the following training activities exist:
      | name            | unit               | date       | time | location    | priority | justification        |
      | Leadership 101  | P2 | 2024-05-20 | MA   | Hall A      | Leaders of Character     | Leadership skills    |
      | Safety Training | P2 |      2024-06-15 | AA   | Outdoor     | Career Readiness   | Safety precautions   |

    Given the status of "Leadership 101" is "pending_commandant_approval"

Scenario: Viewing the statistical charts page
	Given I am on the website user homepage
	When I click on the "Statistical Charts" link
	Then I should be redirected to the training activities chart page
    And I should see a chart
