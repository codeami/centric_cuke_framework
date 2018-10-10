Feature: Log into / out of Policy Center
  Scenario: Log into Policy Center
    Given valid credentials
    When I attempt to log in to Policy Center
    Then I {should} be logged in