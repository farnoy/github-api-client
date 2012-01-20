Feature: Frontend Api
	In order to use API provided by this library properly
	I need to use provided set of objects
  
	Scenario: Existence of Frontend module
		Given I am trying to make use of this library
		Then "Frontend" module should exist
	
	Scenario: Existence of User resource
		Given I am testing "User" resource
		Then The object should exist
	
	Scenario: User's name
		Given I am testing "User" resource
		Then The object's "name" should be "farnoy"
	
	Scenario: Modifying User's name
		Given I am testing "User" resource
		Then The "name" should be writable
	
	Scenario: User's location
		Given I am testing "User" resource
		Then The object's "location" should be "Poland"

	Scenario: Modifying User's location
		Given I am testing "User" resource
		Then The "location" should be writable
	
	Scenario: User's login
		Given I am testing "User" resource
		Then The object's "login" should be "farnoy"
	
	Scenario: Modifying User's login
		Given I am testing "User" resource
		Then The object's "login" should not be writable
