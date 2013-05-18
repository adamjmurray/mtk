require 'spec_helper'

describe MTK::Variable do

  def var(*args)
    ::MTK::Variable.new(*args)
  end

  describe '#name' do
    it 'is the name the variable was constructed with' do
      var('$').name.should == '$'
      var('$$').name.should == '$$'
    end

    it 'cannot be changed after the variable is created' do
      lambda{ var('$').name = '$$$' }.should raise_error
    end
  end

  describe '#value' do
    it 'is the value the variable was constructed with' do
      var(:name, :value).value.should == :value
    end

    it 'can be changed after the variable is created' do
      v = var(:name, :value)
      v.value = 'foo'
      v.value.should == 'foo'
    end
  end

  describe '#==' do
    it "is true when two variables' names are equal" do
      var('$').should == var('$')
    end

    it "is false when two variables' names are not equal" do
      var('$').should_not == var('$$')
    end
  end

end
