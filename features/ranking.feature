Feature: Ranking

  Scenario: Display ranking for not logged in user
    Given few users are registered and solved some problems
    When I go the the home page
    Then I should see the correct ranking with scores

  Scenario: Display ranking for logged in user
    Given I am logged in
    And few users are registered and solved some problems
    When I go the the home page
    Then I should see the correct ranking with scores
