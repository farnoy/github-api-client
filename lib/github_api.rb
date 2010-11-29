#!/usr/bin/ruby
$: << './github_api' << './lib/github_api'

require 'rubygems'
require 'bundler/setup'
gem 'github-api-client'
require 'net/http'
require 'uri'
require 'yaml'
require 'singleton'
require 'active_record'

module GitHub #:nodoc:
  module Config
    Path = {:dir => ENV['HOME'] + "/.github", :dbfile => ENV['HOME'] + "/.github/github.db", :migrations => Gem.loaded_specs['github-api-client'].full_gem_path + "/db/migrate", :secrets => ENV['HOME'] + "/.github" + "/secrets.yml"}
    
    def self.setup
      Dir.mkdir GitHub::Config::Path[:dir] rescue nil
      ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => GitHub::Config::Path[:dbfile]
      ActiveRecord::Migrator.migrate(GitHub::Config::Path[:migrations], nil)
    end
  end
end

GitHub::Config.setup

require 'base'
require 'user'
require 'browser'
gem 'rainbow'


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
