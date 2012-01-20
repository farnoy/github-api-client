#!/usr/bin/env ruby

$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'github-api-client/resource'

class User
  @@attributes = {login: String, name: String, has_repos: true, location: String}
  @@pushables = [:name, :location]
  include Resource
end

u = User.new
u.name = 'Kuba'
p u.login
p u.has_repos = true
p u.has_repos?
