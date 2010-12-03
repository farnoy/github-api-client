#!/usr/bin/env ruby
$LOAD_PATH << './lib/' << './lib/github_api/'

require 'github_api'

unless ARGV.include? 'test'
  # Dev temporary code here
  p GitHub::Repo.get('parndt/hub')
else # launches all-features code
  # Gets repo
  r = GitHub::Repo.get('mojombo/jekyll')
  puts r.fork? 

  GitHub::User.search('chacon').each do |user|
    puts user.name
  end

  # You'll probably get banned on GitHub, so better don't perform this
  #GitHub::Base.sync

  # Prints list of followers logins for user with login kneath
  GitHub::User.new(:login => 'kneath').fetch(:self, :followers).followers.each do |follower|
    puts follower.login
  end

  # Fetches followers and self information for user defined in config/secrets.yml
  p $user.fetch(:self, :followers)

  # Gets simple User information for defunkt
  p GitHub::User.get('defunkt')

  # EXPERIMENTAL
  # Sets email for user defined in config/secrets.yml to test@api.com
  $user.set ['user', 'show', $user.login], 'values[email]' => 'test@api.com'
end
