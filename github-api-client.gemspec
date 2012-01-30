# -*- encoding: utf-8 -*-

$:.unshift File.expand_path("../lib", __FILE__)
require "github-api-client/version"

Gem::Specification.new do |s|
  s.name = "github-api-client"
  s.version = GitHub::Version::String

  s.authors = [%{Jakub Okoński}]
  s.date = "2012-01-30"
  s.description = "Caches retrieved information to your user profile and reuses it when you query again."
  s.email = "kuba@okonski.org"
  s.executables = ["api-browser.rb github-api-client"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "TODO",
    "NEWS"
  ]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  
  s.homepage = %{http://github.com/farnoy/github-api-client}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = %{Library for easy GitHub API browsing}

  s.add_runtime_dependency("rainbow", [">= 1.1.3"])
  s.add_runtime_dependency("rake", ["= 0.8.7"])
  s.add_runtime_dependency("activerecord", [">= 3.1.0"])
  s.add_runtime_dependency("activesupport", [">= 3.1.0"])
  s.add_runtime_dependency("sqlite3", [">= 1.3.5"])
  s.add_runtime_dependency("OptionParser", [">= 0.5.1"])

  s.add_development_dependency("rspec", [">= 2.7.0"])
  s.add_development_dependency("mocha", [">= 0.10.0"])
  s.add_development_dependency("yard", [">= 0.6.0"])
  s.add_development_dependency("cucumber", [">= 1.1.4"])
end
