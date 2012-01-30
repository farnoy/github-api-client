require 'minitest/spec'
MiniTest::Unit.autorun
require 'rspec/expectations'
require 'rspec/matchers'
require 'mocha'

describe "Testing framework" do
  it "executes" do
    user = Struct.new("User", :name).new('kuba')
    user.stubs(:age).returns(3)
    3.should eq(user.age)
  end
end
