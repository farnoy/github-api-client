#!/usr/bin/env ruby
$LOAD_PATH << './app/models/'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => 'ruby.db'

Dir.glob('app/models/*.rb').each do |model|
  require model.scan(/\/([a-z]+).rb/).flatten.first
end
