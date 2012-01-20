Feature: User frontend
	In order to use API provided by this library properly
	I need to use provided set of objects
  
	Scenario: Existence of User class
		Given I am trying to make use of this library
		Then "User" resource should exist
	
	Scenario: Existence of User resource
		Given the "User" resource
		Then the object should exist
	
	Scenario: User's name
		Given the "User" resource
		And the "name" property
		Then the property should be "Chris Wanstrath"
		And the property should be writable
	
	Scenario: User's location
		Given the "User" resource
		And the "location" property
		Then the property should be "San Francisco"
		And the property should be writable
	
	Scenario: User's company
		Given the "User" resource
		And the "company" property
		Then the property should be "GitHub"
		And the property should be writable
	
	Scenario: User's login
		Given the "User" resource
		And the "login" property
		Then the property should be "defunkt"
		And the property should not be writable
	
	Scenario: User's bio
		Given the "User" resource
		And the "bio" property
		Then the property should be "The greatest and best programmer in the world."
		Then the property should be writable
	
	Scenario: User's email
		Given the "User" resource
		And the "email" property
		Then the property should be "chris@wanstrath.com"
		And the property should be writable
	
	Scenario: User's hireable status
		Given the "User" resource
		And the "hireable" property
		Then the property should be true
		And the property should be writable
	
	Scenario: User's blog
		Given the "User" resource
		And the "blog" property
		Then the property should be true
		And the property should be writable
	
	Scenario: Saving User
		Given the "User" resource
		And that I'm authenticated as this resource
		And I'm tracking browser actions
		When I set "name" to "test"
		And I update the resource
		Then the resource changes should be cleared
		And the browser fires up a PATCH request at "/user"
