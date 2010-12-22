Before do
  %w(Repo User).each do |attr|
    GitHub.const_get(attr).delete_all
  end
end

When /^I fetch user '(.*)'$/ do |login|
  @record = GitHub::User.get(login)
end

Then /^My local database should contain that record$/ do
  @record.class.find(@record.id).should == @record
  #query.should_not be_empty
  #query.should == [@record]
end

Then /^That record's '(.*)' should be '(.*)'$/ do |sig, prop|
  @record.send(sig.to_sym).should == prop
end
