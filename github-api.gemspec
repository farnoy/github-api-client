Gem::Specification.new do |s|
  s.name = "github-api-client"
  s.version = '0.1'
  s.summary = 'Library for easy GitHub API browsing'
  s.description = s.summary
  s.author = 'Jakub Okoński'
  s.email = 'kuba@okonski.org'
  s.homepage = 'http://github.com/farnoy/github-api-client'
  
  s.files = Dir['lib/github_api.rb', 'lib/github_api/*']
  s.require_path = 'lib'
  s.has_rdoc = false
end
