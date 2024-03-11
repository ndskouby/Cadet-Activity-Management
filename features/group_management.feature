Feature: Group management

    As a user of the website
    So that I don’t see things I don’t care about
    I would expect to be in a variety of groups and see my memberships; 
        groups may have a direct parent, and I’d want to see the other parent groups I’m in

Background:
	Given I am a logged-in user with name "John Doe"

Scenario: View homepage and see my groups
    Given I am on the website user homepage
    Then I should see a list of groups that I am in
