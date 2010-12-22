#!/usr/bin/ruby

require 'rubygems'
gem 'github-api-client'

$:.unshift File.dirname(__FILE__) if Dir.pwd != Gem.loaded_specs['github-api-client'].full_gem_path # devel trick

require 'net/http'
require 'uri'
require 'yaml'
require 'singleton'
require 'active_record'
require 'core_ext/habtm'
require 'rainbow'
require 'progressbar'
require 'github-api-client/config'

GitHub::Config.setup

require 'github-api-client/base'
require 'github-api-client/user'
require 'github-api-client/repo'
require 'github-api-client/browser'

unless $user = GitHub::User.where(GitHub::Config::Secrets).first
  $user = GitHub::User.create(GitHub::Config::Secrets)
end if GitHub::Config::Secrets


# General placeholder for all of the GitHub API sweets
module GitHub
end
