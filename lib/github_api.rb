#!/usr/bin/ruby
$LOAD_PATH << './github_api'

require 'net/http'
require 'uri'
require 'yaml'
require 'user'
require 'browser'

begin
  $user = GitHub::User.new
  YAML::load_file('config/secrets.yml')[:user].each_pair do |k, v|
    $user.send ("#{k.to_sym}=").to_sym, v
  end
  
rescue Errno::ENOENT
  puts "Could not load config/secrets.yml, did you defined it?"
end

module GitHub
  def self.base_uri
    "http://github.com/api/v2/yaml"
  end
end
