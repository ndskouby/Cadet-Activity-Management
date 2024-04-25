Feature: Admin User of the App

  As an admin user
  I want to be able to use all admin features
  So that I can perform administrative tasks

  Background: 
    Given I am an logged-in admin user with name "John Doe"

  Scenario: Access to the admin page
    Then I should see "Admin" on the nav bar
    When I click on the "Admin" link
    Then I should be on the Admin page   

  Scenario: Add new user
    Given I am on the new user data page
    When I fill out all forms
    And I click the "Create User" button
    Then I should see "User was successfully created"
    And I should be redirected to the Admin Page
  
  Scenario: Importing a CSV file
    Given I am on the admin page
    And I click the Browse button and choose a CSV file
    And I click the "Import" button
    Then I should see "Users Imported"
  
  Scenario: Impersonating a user
    Given I am on the admin page
    And I click the "impersonate" button for the user "bob smith"
    Then I should see "You are now impersonating bobsmith@tamu.edu"

  Scenario: Delete an user
    Given I am on the user detail page
    When I click the delete button
    Then I should see "User was successfully deleted"
    And I should be redirected to the Admin Page