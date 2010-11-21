#!/usr/bin/ruby
$LOAD_PATH << './github_api'

require 'net/http'
require 'uri'
require 'yaml'
require 'singleton'
require 'base'
require 'user'
require 'browser'

begin
  $user = GitHub::User.new
  $user.build YAML::load_file('config/secrets.yml')[:user]
  
rescue Errno::ENOENT
  puts "Could not load config/secrets.yml, have you defined it?"
end

module GitHub
  def self.base_uri
    "http://github.com/api/v2/yaml"
  end
end
