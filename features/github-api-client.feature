Feature: Fetching Objects
  In order to fetch objects from GitHub
  I just need to fire up few commands

  Scenario: Fetching user information
    Given I fetch user "schacon"
    Then My local database should contain that record
    And That record's "name" should be "Scott Chacon"
  
  Scenario: Fetching repo information
    Given I fetch repo "mojombo/jekyll"
    Then My local database should contain that record
    And That record's "login" of the "owner" should be "mojombo"
