Before do
  %w(Repo User Organization).each do |attr|
    GitHub.const_get(attr).delete_all
  end
end

Given /^I fetch user "(.*)"$/ do |login|
  @record = GitHub::User.get(login)
end

Given /^I fetch repo "(.*)"$/ do |permalink|
  @record = GitHub::Repo.get(permalink)
end

Given /^I fetch organization "(.*)"$/ do |login|
  @record = GitHub::Organization.get(login)
end

Then /^my local database should contain that record$/ do
  @record.class.find(@record.id).should == @record
end

Then /^that record's "([^"]*)" should be "([^"]*)"$/ do |sig, prop|
  @record.send(sig.to_sym).should == prop
end

Then /^that record's "([^"]*)" of the "([^"]*)" should be "([^"]*)"$/ do |sig, type, prop|
  @record.send(type.to_sym).send(sig.to_sym).should == prop
end

Given /^I set verbose option to "(.*)"$/ do |bool|
  GitHub::Config::Options[:verbose] = bool
end
