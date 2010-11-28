#!/usr/bin/ruby
$LOAD_PATH << './github_api' << './lib/github_api'

require 'net/http'
require 'uri'
require 'yaml'
require 'singleton'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => 'ruby.db'

require 'base'
require 'user'
require 'browser'
require 'rainbow'


begin
  unless $user = GitHub::User.where(YAML::load_file('config/secrets.yml')['user']).first
    $user = GitHub::User.create(YAML::load_file('config/secrets.yml')['user'])
  end rescue puts "Run rake db:migrate task and restart application"
  
rescue Errno::ENOENT
  puts "Could not load config/secrets.yml, have you defined it?"
end

module GitHub #:nodoc:
end
