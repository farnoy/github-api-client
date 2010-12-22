# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "github-api-client"
  gem.homepage = "http://github.com/farnoy/github-api-client"
  gem.license = "MIT"
  gem.summary = %Q{Library for easy GitHub API browsing}
  gem.description = %Q{Caches retrieved information to your user profile and reuses it when you query again.}
  gem.email = "kuba@okonski.org"
  gem.authors = ["Jakub Okoński"]
  gem.add_runtime_dependency('rainbow', '>=1.1')
  gem.add_runtime_dependency('activerecord', '>=3.0.3')
  gem.add_runtime_dependency('sqlite3-ruby', '>=1.3.2')
  
  gem.add_development_dependency 'yard', '>= 0.6.0'
  gem.add_development_dependency 'rspec', '>= 2.3.0'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'bundler', '>= 1.0.0'
  gem.add_development_dependency 'jeweler', '>= 1.5.2'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
