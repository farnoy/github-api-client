#!/usr/bin/env ruby
$LOAD_PATH << './lib/github_api/'

require 'net/http'
require 'uri'
require 'yaml'
require 'user'

begin
  $user = GitHub::User.new
  YAML::load_file('config/secrets.yml')[:user].each_pair do |k, v|
    $user.send ("#{k.to_sym}=").to_sym, v
  end
  
rescue Errno::ENOENT
  puts "Could not load config/secrets.yml, did you defined it?"
end

uri = URI.parse("http://github.com/api/v2/yaml/user/show/#{$user.login}")

Net::HTTP.get_print uri
