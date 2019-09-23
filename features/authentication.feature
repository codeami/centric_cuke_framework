Feature: Log into / out of Policy Center
  Scenario: Log into Policy Center
    Given valid credentials
    When I attempt to log in
    Then I should be logged in

  Scenario: Log into Policy Center
    Given I have logged into Policy Center
    When I log out
    Then I should not be logged in