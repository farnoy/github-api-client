#!/usr/bin/env ruby
$:.unshift('./lib/')

require 'github-api-client'

puts GitHub::Config::Version

unless ARGV.include? 'test'
  # Dev temporary code here
  # p GitHub::Repo.get('parndt/hub').fetch(:watchers).class
  p GitHub::Repo.get('farnoy/github-api-client').owner
  p GitHub::Repo.get('rails/rails').owner
  p GitHub::Organization.get('rails').fetch(:repositories).repositories
else # launches all-features code
  # Performance tests
  #GitHub::Organization.get('rails').fetch(:repositories).repositories
  p GitHub::Repo.get('parndt/hub').parent.fetch(:self, :watchers).watchers
  GitHub::User.get('kneath').fetch(:followers, :followings)
  GitHub::User.get('schacon').fetch(:organizations).organizations
  GitHub::Organization.get('github').fetch(:members).members
end
