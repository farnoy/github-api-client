require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GitHub Api Client" do
  context "configuration" do
    it "should create database on first run" do
      File.stubs(:exists?).returns(false)
      ActiveRecord::Migrator.expects(:migrate).with(GitHub::Config::Path[:migrations], nil).once
      GitHub::Config.setup
    end
  end
  
  context "basics" do
    it "should save objects to database"
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
