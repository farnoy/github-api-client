Gem::Specification.new do |s|
  s.name = "github-api-client"
  s.version = '0.1.1.3'
  s.summary = 'Library for easy GitHub API browsing'
  s.description = s.summary
  s.author = 'Jakub Okoński'
  s.email = 'kuba@okonski.org'
  s.homepage = 'http://github.com/farnoy/github-api-client'
  
  s.files = Dir['lib/github_api.rb', 'lib/github_api/*', 'db/*/**', 'lib/core_ext/*']
  s.require_path = 'lib'
  s.has_rdoc = false
  
  s.add_dependency('rainbow', '>=1.1')
  s.add_dependency('activerecord', '>=3.0.3')
  s.add_dependency('sqlite3-ruby', '>=1.3.2')
end
