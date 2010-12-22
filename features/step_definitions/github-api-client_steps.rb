Before do
  %w(Repo User).each do |attr|
    GitHub.const_get(attr).delete_all
  end
end

Given /^I fetch user '(.*)'$/ do |login|
  @record = GitHub::User.get(login)
end

Then /^My local database should contain that record$/ do
  @record.class.find(@record.id).should == @record
end

Then /^That record's '(.*)' should be '(.*)'$/ do |sig, prop|
  @record.send(sig.to_sym).should == prop
end

Given /^I set verbose option to '(.*)'$/ do |bool|
  GitHub::Config::Options[:verbose] = bool
end
