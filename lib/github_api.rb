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
require 'github_api/config'

GitHub::Config.setup

require 'github_api/base'
require 'github_api/user'
require 'github_api/repo'
require 'github_api/browser'

unless $user = GitHub::User.where(GitHub::Config::Secrets).first
  $user = GitHub::User.create(GitHub::Config::Secrets)
end if GitHub::Config::Secrets


# General placeholder for all of the GitHub API sweets
module GitHub
end
