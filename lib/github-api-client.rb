require 'rubygems'

ROOT = File.expand_path('../', File.dirname(__FILE__))

$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'uri'
require 'json'
require 'singleton'
require 'active_record'
require 'core_ext/habtm'
require 'rainbow'
require 'github-api-client/config'
require 'github-api-client/strategy'

require 'github-api-client/base'
#require 'github-api-client/user'
#require 'github-api-client/repo'
#require 'github-api-client/organization'
require 'github-api-client/browser'
require 'github-api-client/helpers'

# Resources
require 'github-api-client/resource'
Dir[File.expand_path("github-api-client/resources/*.rb", File.dirname(__FILE__))].each do |lib|
	require lib
end

# This hard-coded if's will be soon replaced by Option Parser
GitHub::Config::Options[:verbose] = true if ARGV.include? '--verbose'
if ARGV.include? '--reset-db'
  GitHub::Config.reset
else
  GitHub::Config.setup
end

# Fetchers
require 'github-api-client/fetchers'
Dir[File.expand_path("github-api-client/fetchers/*.rb", File.dirname(__FILE__))].each do |lib|
	require lib
end

#unless $user = GitHub::User.where(GitHub::Config::Secrets).first
#  $user = GitHub::User.create(GitHub::Config::Secrets)
#end if GitHub::Config::Secrets


# Strategies
require 'github-api-client/strategies/ask'
require 'github-api-client/strategies/remote'
require 'github-api-client/strategies/local'
GitHub::Config::Options[:strategy] = GitHub::Strategies::Ask # GitHub::CachingStrategy


# General placeholder for all of the GitHub API sweets
module GitHub
end
