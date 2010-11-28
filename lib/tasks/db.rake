require 'active_record'

task :environment do
  Dir.mkdir ENV['HOME'] + "/.github" if !Dir.entries(ENV['HOME']).include? ".github"
  ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => "#{ENV['HOME']}/.github/ruby.db"
end

namespace :db do
  desc "Migrate the database."
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  namespace :migrate do
    desc 'Upgrade to VERSION.'
    task :up => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      ActiveRecord::Migrator.run(:up, "db/migrate/", version)
    end

    desc 'Downgrade to VERSION.'
    task :down => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      ActiveRecord::Migrator.run(:down, "db/migrate/", version)
    end
  end

  desc 'Rollbacks STEPs down, default: 1'
  task :rollback => :environment do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback('db/migrate/', step)
  end
end
