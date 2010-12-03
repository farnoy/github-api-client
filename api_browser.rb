#!/usr/bin/env ruby
$LOAD_PATH << './lib/' << './lib/github_api/'

require 'github_api'

unless ARGV.include? 'test'
  # Dev temporary code here
  p GitHub::Repo.get('parndt/hub').parent.fetch(:self, :watchers).watchers
else # launches all-features code
  # Performance tests
  GitHub::Repo.get('mojombo/jekyll').fetch(:self, :watchers)
  GitHub::Repo.get('schacon/kidgloves').fetch(:watchers).watchers.each  
  GitHub::Repo.get('parndt/hub').parent.fetch(:self, :watchers).watchers
  GitHub::User.get('kneath').fetch(:followers, :followings)
  GitHub::User.get('defunkt').fetch(:followers, :followings)
  GitHub::User.get('schacon').fetch(:followers, :followings)
end
