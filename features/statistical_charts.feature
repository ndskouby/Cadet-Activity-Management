Feature: Accessible Website for Corps of Cadets

As a training officer, unit leader, or upper corps leadership
So that I can view the status and completion of the CMDTS goals that a unit is supposed to achieve.
I want to be able to see the bar graph and sheet of completion time and training type for a certain unit.

Background:
	Given I am a logged-in user with name "John Doe"

Scenario: Viewing the statistical charts page
	Given I am on the website user homepage
	When I click on the "Statistical Charts" link
	Then I should be redirected to the training activities chart page
	And I should see a chart
