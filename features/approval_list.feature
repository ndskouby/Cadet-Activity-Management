Feature: Approval list

    As a training officer, unit leader, or upper corps leadership
    So that I can remark on events quickly
    I want to be able to see all events that need my attention in order, like a to-do list

Background:
	Given I am a logged-in user with name "John Doe"
    Given the following training activities exist:
      | name            | date       | time | location    | priority | justification        |
      | Leadership 101  | 2024-05-20 | MA   | Hall A      | Leaders of Character     | Leadership skills    |
      | Safety Training | 2024-06-15 | AA   | Outdoor     | Career Readiness   | Safety precautions   |


Scenario: Accessing the approval page
    Given that I am on the user homepage
    When I click the "Audit Activities" link
    Then I should be on the Audit Activities page

Scenario: Viewing individual events for approval
    Given that I am on the Audit Activities page
    When I click audit for "Leadership 101"
    Then I should be on the approval details page for "Leadership 101"

Scenario: Approving event
    Given that I am on the approval details page for "Leadership 101"
    And that the status of "Leadership 101" is "pending_minor_unit_approval"
    When I press the "Approve" button
    Then the status of "Leadership 101" should be "pending_major_unit_approval"

Scenario: Single approval is not sufficient
    Given that I am on the approval details page for "Leadership 101"
    And that the status of "Leadership 101" is "pending_minor_unit_approval"
    When I press the "Approve" button
    Then the status of "Leadership 101" should not be "approved"

Scenario: Request revision event
    Given that I am on the approval details page for "Leadership 101"
    And that the status of "Leadership 101" is "pending_minor_unit_approval"
    When I press the "Request Revision" button
    Then the status of "Leadership 101" should be "revision_required_by_submitter"

Scenario: Reject event
    Given that I am on the approval details page for "Safety Training"
    And that the status of "Safety Training" is "pending_minor_unit_approval"
    And I press the "Reject" button
    And I press the "Confirm Reject" button
    Then the status of "Safety Training" should be "rejected"
