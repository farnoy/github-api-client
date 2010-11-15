#!/usr/bin/env ruby
$LOAD_PATH << './app/models/'
require 'net/http'
require 'uri'
require 'active_record'
require 'yaml'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => 'ruby.db'

Dir.glob('app/models/*.rb').each do |model|
  require model.scan(/\/([a-z]+).rb/).flatten.first
end

begin
  loaded_user = GitHub::User.new(YAML::load_file('config/secrets.yml')[:user])
  if GitHub::User.last
    if GitHub::User.last.login == loaded_user.login && GitHub::User.last.token == loaded_user.token
      $user = GitHub::User.last
    end
  else
    GitHub::User.delete_all
    $user = GitHub::User.create(YAML::load_file('config/secrets.yml')[:user])
  end
  
rescue ActiveRecord::StatementInvalid, Errno::ENOENT
  #TODO: Switching and doing proper actions for single error
  puts "Could not load config/secrets.yml, did you defined it?"
  puts 'Error: Did you run rake db:migrate?'
  puts 'Trying to do it for you...'
  system 'rake db:migrate'
end

uri = URI.parse("http://github.com/api/v2/yaml/user/show/#{$user.login}")

Net::HTTP.get_print uri
