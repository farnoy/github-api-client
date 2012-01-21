Feature: User frontend
	In order to use API provided by this library properly
	I need to use provided set of objects
  
	Background:
		Given the "User" resource

	Scenario: Existence of User class
		Given I am trying to make use of this library
		Then "User" resource should exist
	
	Scenario: Existence of User resource
		Given the "User" resource
		Then the object should exist
	
	Scenario: User's name
		Given the "name" property
		Then the property should be "Chris Wanstrath"
			And the property should be writable
	
	Scenario: User's location
		Given the "location" property
		Then the property should be "San Francisco"
			And the property should be writable
	
	Scenario: User's company
		Given the "company" property
		Then the property should be "GitHub"
			And the property should be writable
	
	Scenario: User's login
		Given the "login" property
		Then the property should be "defunkt"
			And the property should not be writable
	
	Scenario: User's bio
		Given the "bio" property
		Then the property should be "The greatest and best programmer in the world."
		Then the property should be writable
	
	Scenario: User's email
		Given the "email" property
		Then the property should be "chris@wanstrath.com"
			And the property should be writable
	
	Scenario: User's hireable status
		Given the "hireable" property
		Then the property should be true
			And the property should be writable
	
	Scenario: User's blog
		Given the "blog" property
		Then the property should be "http://chriswanstrath.com/"
			And the property should be writable
	
	Scenario: Saving User
		Given that I am authenticated as this resource
			And I am tracking browser actions
		When I set "name" to "test"
			And I update the resource
		Then the resource changes should be cleared
			And the browser fires up a PATCH request at "/user"
	
	Scenario: Getting user's public repos
		Given that I am trying to fetch user's public repos
			But I am not authenticated
		When I fetch resource's repositories
		Then I can access resource's repositories
			And accessed data should be a set of repositories
	
	Scenario: Getting all user's repos
		Given that I am trying to fetch user's repos
			And I am authenticated
		When I fetch resource's repositories
		Then I can access resource's private repositories
			And accessed data should be a set of repositories
	
	Scenario: Getting user's followers
		Given that I am trying to fetch resource's followers
		When I fetch resource's followers
		Then I can access resource's followers
			And accessed data should be a set of users
	
	Scenario: Getting user's followings
		Given that I am trying to fetch resource's followings
		When I fetch resource's followings
		Then I can access resource's followings
			And accessed data should be a set of users
