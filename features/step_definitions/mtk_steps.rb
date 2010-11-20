def object_for( arg )
  arg, type = *( arg.split(' ').find_all{|s| not s.empty?} )
  if type 
    "#{type}.new(#{arg})"
  else
    arg
  end
end


When /^I add "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  @result = eval "#{object_for arg1} + #{object_for arg2}"
end


Then /^I should have "([^"]*)"$/ do |expected|
  @result.to_s.should == expected
end


