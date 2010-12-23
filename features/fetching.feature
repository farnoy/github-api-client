Feature: Fetching Objects
  In order to fetch objects from GitHub
  I just need to request a function from a model

  Scenario: Fetching user information
    Given I want to fetch user "schacon"
    Then my local database should contain that record
    And that record's "name" should be "Scott Chacon"
  
  Scenario: Fetching repo information
    Given I want to fetch repo "mojombo/jekyll"
    Then my local database should contain that record
    And that record's "login" of the "owner" should be "mojombo"
