Given /^I included "([^"]*)"$/ do |module_name|
  #TODO: this approach sucks... there has got to be a better way
  @module = module_name
end

When /^I add "([^"]*)" and "([^"]*)" "([^"]*)"$/ do |arg1, arg2, arg2_type|
  @result = eval "#{arg1} + #{@module}::#{arg2_type}.new(#{arg2})"
end

When /^I add "([^"]*)" "([^"]*)" and "([^"]*)"$/ do |arg1, arg1_type, arg2|
  @result = eval "#{@module}::#{arg1_type}.new(#{arg1}) + #{arg2}"
end

Then /^I should have "([^"]*)"$/ do |expected|
  @result.to_s.should == expected
end


