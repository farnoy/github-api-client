# -*- encoding: utf-8 -*-

require 'rubygems'
require 'bundler'
include Rake::DSL
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
include Rake::DSL # supressess jeweler warnings

desc 'run irb session against this library'
task :irb do
  system 'irb -I./lib -r github-api-client'
end

desc 'run test suite'
task :tests do
  Dir[File.dirname(__FILE__) + '/spec/*_spec.rb'].each do |file|
    require file
  end
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
