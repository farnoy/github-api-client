require 'minitest/spec'
MiniTest::Unit.autorun
require 'rspec/expectations'
require 'rspec/matchers'

describe "Testing framework" do
  it "executes" do
    assert_equal 3, 3
  end
end
