Feature: Policy Search

  Scenario: Quick search for a policy by policy number
    Given I have logged into Policy Center
    When I search for policy number 4775950377-01 using the drop down
    Then I should be on the policy tab viewing the searched for policy

  Scenario: Search for a policy by policy number
    Given I have logged into Policy Center
    When I search for policy number 4775950377-01 using the search tab
    Then I should be able to find that policy number in the grid

  Scenario: Open policy from search
    Given I have logged into Policy Center
    When I search for policy number 4775950377-01 using the search tab
    And I click on the policy number in the results
    Then I should be on the policy tab viewing the searched for policy