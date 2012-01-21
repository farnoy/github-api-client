#!/usr/bin/env ruby

$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'github-api-client/resource'

class User
  @@attributes = {login: String, name: String, has_repos: true, location: String}
  @@pushables = [:name, :location]
	@@associations = {repositories: [nil, -> { has_many :repositories, :class_name => Repo}]}
  include Resource
end

u = User.new
u.name = 'Kuba'
u.attributes[:has_repos] = true
u.save
p u.repositories
