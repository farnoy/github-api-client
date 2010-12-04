#!/usr/bin/env ruby
$LOAD_PATH << './lib/' << './lib/github_api/'

require 'github_api'

GitHub::Config::Options[:verbose] = true if ARGV.include? '--verbose'

unless ARGV.include? 'test'
  # Dev temporary code here
  #GitHub::Repo.get('parndt/hub').parent.fetch(:self, :watchers).watchers
  GitHub::User.get('schacon').fetch(:self, :followers, :followings)
else # launches all-features code
  # Performance tests
  GitHub::Repo.get('mojombo/jekyll').fetch(:self, :watchers)
  GitHub::Repo.get('schacon/kidgloves').fetch(:watchers).watchers.each  
  GitHub::Repo.get('parndt/hub').parent.fetch(:self, :watchers).watchers
  GitHub::User.get('kneath').fetch(:followers, :followings)
  GitHub::User.get('defunkt').fetch(:followers, :followings)
  GitHub::User.get('schacon').fetch(:followers, :followings)
end
