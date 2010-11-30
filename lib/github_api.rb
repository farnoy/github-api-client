#!/usr/bin/ruby
#$: << '../'

require 'rubygems'
gem 'github-api-client'
require 'net/http'
require 'uri'
require 'yaml'
require 'singleton'
require 'active_record'
require 'core_ext/habtm'

# General placeholder for all of the GitHub API sweets
module GitHub
  # Keeps all the configuration stuff
  module Config
    # Constant with defined all the paths used in the application
    Path = {:dir => ENV['HOME'] + "/.github", :dbfile => ENV['HOME'] + "/.github/github.db", :migrations => Gem.loaded_specs['github-api-client'].full_gem_path + "/db/migrate", :secrets => ENV['HOME'] + "/.github" + "/secrets.yml"}
    
    # Sets up the database and migrates it
    # @return [nil]
    def self.setup
      Dir.mkdir GitHub::Config::Path[:dir] rescue nil
      ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => GitHub::Config::Path[:dbfile]
      ActiveRecord::Migrator.migrate(GitHub::Config::Path[:migrations], nil)
    end
  end
end

GitHub::Config.setup

require 'github_api/base'
require 'github_api/user'
require 'github_api/browser'
require 'rainbow'


begin
  unless $user = GitHub::User.where(YAML::load_file(GitHub::Config::Path[:secrets])['user']).first
    $user = GitHub::User.create(YAML::load_file(GitHub::Config::Path[:secrets])['user'])
  end
  
rescue Errno::ENOENT
  puts "Could not load config/secrets.yml, have you defined it?"
  puts "Putting example secrets file in your #{GitHub::Config::Path[:secrets]}"
  File.open(GitHub::Config::Path[:secrets], 'w') do |f|
    f.write <<-config
user:
 login: login
 token: private_token
    config
  end
end
