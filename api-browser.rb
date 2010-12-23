#!/usr/bin/env ruby
$:.unshift('./lib/')

require 'github-api-client'

GitHub::Config::Options[:verbose] = true if ARGV.include? '--verbose'

GitHub::Config.reset if ARGV.include? '--reset-db'

puts GitHub::Config::Version

unless ARGV.include? 'test'
  # Dev temporary code here
  p GitHub::Organization.get('github')
else # launches all-features code
  # Performance tests
  GitHub::Repo.get('mojombo/jekyll').fetch(:self, :watchers)
  GitHub::Repo.get('schacon/kidgloves').fetch(:watchers).watchers.each  
  GitHub::Repo.get('parndt/hub').parent.fetch(:self, :watchers).watchers
  GitHub::User.get('kneath').fetch(:followers, :followings)
  GitHub::User.get('defunkt').fetch(:followers, :followings)
  GitHub::User.get('schacon').fetch(:followers, :followings)
end
