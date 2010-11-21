#!/usr/bin/env ruby
$LOAD_PATH << './lib/' << './lib/github_api/'

require 'github_api'

#puts $user.get(:self)
#puts $user.post(:me)
#$user.set ['user', 'show', $user.login], 'values[email]' => 'test@api.com'
puts $user.followers(:self)
