require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GitHub Api Client" do
  
  context "configuration" do
    
    it "should create database on first run" do
      File.stubs(:exists?).returns(false)
      ActiveRecord::Migrator.expects(:migrate).with(GitHub::Config::Path[:migrations], nil).once
      GitHub::Config.setup
    end
    
    it "should not migrate database every time" do
      File.stubs(:exists?).returns(true)
      ActiveRecord::Migrator.expects(:migrate).never
      GitHub::Config.setup
    end
    
    context "options" do
      
      context "with enabled verbose" do
        
        it "should print messages" do
          GitHub::Config::Options.expects(:"[]").with(:verbose).returns(true)
          $stdout.expects(:puts).once
          GitHub::Browser.get("/users/show/farnoy")
        end
        
      end
      
      context "with disabled verbose" do
        
        it "should not print messages" do
          GitHub::Config::Options.expects(:"[]").with(:verbose).returns(false)
          $stdout.expects(:puts).never
          GitHub::Browser.get("/users/show/farnoy")
        end
        
      end
                
    end
  end
  
  context "basics" do
    
    it "should save objects to database" do
      u = GitHub::User.get("farnoy")
      u.should == GitHub::User.find(u.id)
    end
    
  end
  
  context "version" do
    
    it "should assign properly" do
      GitHub::Config::Version.should == File.read('VERSION')
    end
    
    it "should alias CAPITALIZED name for maniacs" do
      GitHub::Config::Version.should == GitHub::Config::VERSION
    end
    
  end
end
