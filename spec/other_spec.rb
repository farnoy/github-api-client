require 'minitest/spec'
MiniTest::Unit.autorun
require 'rspec/expectations'
require 'rspec/matchers'
require 'mocha'

describe "Testing framework other" do
  it "executes" do
    user = stub(:money => 50)
    order = stub(:total_amount => 49.99)

    user.money.should satisfy { |money| money > order.total_amount }
  end
end
