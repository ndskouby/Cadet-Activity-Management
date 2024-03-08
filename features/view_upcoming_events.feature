Feature: Viewing Upcoming Events

	As a user curious about upcoming events,
	I want to be able to see a sorted list of all upcoming events,
	So that I can know what others are doing.

Scenario: Viewing the list of upcoming events
	Given I am on the homepage
	When I click on the "Upcoming Events" link
	Then I should be taken to the upcoming events page
	And I should see a list of upcoming events sorted by date

Scenario: Events are sorted by nearest upcoming date
	Given I am on the upcoming events page
	When I look at the list of upcoming events
	Then the events should be listed in chronological order starting with the nearest date

Scenario: Viewing details of an event
	Given I am on the upcoming events page
	When I click on an event title
	Then I should be taken to a page with details of the selected event

Scenario: Searching for events
	Given I am on the upcoming events page
	When I enter a search term in the search box
	And I click the search button
	Then I should see a list of upcoming events that match the search term



