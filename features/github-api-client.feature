Feature: Fetching Objects
  In order to fetch objects from GitHub
  I just need to fire up few commands

  Scenario: Fetching user information
    When I fetch user 'schacon'
    Then My local database should contain that record
    And That record's 'name' should be 'Scott Chacon'
