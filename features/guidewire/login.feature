Feature: User can login, non-users can't
  The system should allow people to log in with a username and password

  @fixture_valid_user
  Scenario: Valid user
    Given I am on the login page
    When I attempt to log in
    Then I should be logged in