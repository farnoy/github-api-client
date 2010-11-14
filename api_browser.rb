#!/usr/bin/env ruby
$LOAD_PATH << './'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => 'ruby.db'

Dir.glob('app/models/*.rb').each do |model|
require model
end
