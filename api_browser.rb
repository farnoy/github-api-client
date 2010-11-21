#!/usr/bin/env ruby
$LOAD_PATH << './lib/' << './lib/github_api/'

require 'github_api'

GitHub::User.search(' ').each do |user|
  puts user.name_safe + "  " + user.followers_safe.to_s + "  " + user.repos_safe.to_s
end
#p $user.get
#puts $user.post(:me)
#$user.set ['user', 'show', $user.login], 'values[email]' => 'test@api.com'
#puts $user.followers('schacon')
#p GitHub::User.get('schacon')
