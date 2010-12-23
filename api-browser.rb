#!/usr/bin/env ruby
$:.unshift('./lib/')

require 'github-api-client'

puts GitHub::Config::Version

unless ARGV.include? 'test'
  # Dev temporary code here
  p GitHub::Organization.get('github')
  p GitHub::Organization.get('github').fetch(:members).members
else # launches all-features code
  # Performance tests
  GitHub::Repo.get('mojombo/jekyll').fetch(:self, :watchers)
  GitHub::Repo.get('schacon/kidgloves').fetch(:watchers).watchers.each  
  GitHub::Repo.get('parndt/hub').parent.fetch(:self, :watchers).watchers
  GitHub::User.get('kneath').fetch(:followers, :followings)
  GitHub::User.get('defunkt').fetch(:followers, :followings)
  GitHub::User.get('schacon').fetch(:followers, :followings)
end
