Feature: Quotes
  @fixture_account_demo
  Scenario: Create a quote
    Given I have logged into Policy Center
    And I create a new company account from my fixture file
    And I add a new product to my new account
