#!/usr/bin/env ruby
$LOAD_PATH << './lib/' << './lib/github_api/'

require 'github_api'

#yaml = YAML::load $user.get('schacon')
#puts GitHub::User.new.build yaml['user']
#u = GitHub::Helper.build_from_yaml yaml
#puts $user.post(:me)
#$user.set ['user', 'show', $user.login], 'values[email]' => 'test@api.com'
#puts $user.followers('schacon')
YAML::load(GitHub::Browser.get('/user/search/chacon'))['users'].each do |user|
  puts user['name']
end
