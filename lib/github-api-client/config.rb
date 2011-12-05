module GitHub
  # Keeps all the configuration stuff
  module Config
    # Constant with defined all the paths used in the application
    Path = {
      :dir        => ENV['HOME'] + "/.github", 
      :dbfile     => ENV['HOME'] + "/.github/github.db", 
      :migrations => ROOT +  "/db/migrate", 
      :secrets    => ENV['HOME'] + "/.github" + "/secrets.yml"
    } 
    
    Version = File.read(
      ROOT + "/VERSION"
    )
    VERSION = Version
    
    # Secrets array, uses env vars if defined
    Secrets = case
    when ENV['GITHUB_USER'] && ENV['GITHUB_TOKEN']
      {
        "login" => ENV['GITHUB_USER'], 
        "token" => ENV['GITHUB_TOKEN']
      }
    when `git config --global github.user` && !`git config --global github.token`
      {
        "login" => `git config --global github.user`.strip, 
        "token" => `git config --global github.token`.strip
      } if `git config --global github.user` && !`git config --global github.token`
    else
      begin
        # If not env vars, then ~/.github/secrets.yml
        YAML::load_file(GitHub::Config::Path[:secrets])['user']
      rescue Errno::ENOENT
        # Eye candy with rainbow
        puts <<-report
You have three ways of defining your user to have authenticated access to your API:
  #{"1.".color(:cyan)} Put a file in: #{GitHub::Config::Path[:secrets].color(:blue).bright}
    Define in yaml:
      #{"user".color(:yellow).bright}:
        #{"login".color(:green).bright}: #{"your_login".color(:magenta)}
        #{"token".color(:blue).bright}: #{"your_token".color(:magenta)}
  #{"2.".color(:cyan)} Put #{"GITHUB_USER".color(:green).bright} and #{"GITHUB_TOKEN".color(:blue).bright} in your environment, so github-api-client can read it.
  #{"3.".color(:cyan)} Configure your global git profile as defined here #{"http://help.github.com/git-email-settings/".color(:blue).bright}

      report
      end
    end
    
    Options = {
      :verbose => false
    }
    
    # Sets up the database and migrates it
    # @return [nil]
    def self.setup
      Dir.mkdir GitHub::Config::Path[:dir] rescue nil
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3', 
        :database => GitHub::Config::Path[:dbfile]
      )
      ActiveRecord::Migrator.migrate(
        GitHub::Config::Path[:migrations], 
        nil
      ) if not File.exists? GitHub::Config::Path[:dbfile]
    end
    
    def self.reset
      system "rm #{Path[:dbfile]}"
      setup
    end
  end
end
