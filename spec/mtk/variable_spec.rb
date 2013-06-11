require 'spec_helper'

describe MTK::Lang::Variable do

  def var(*args)
    ::MTK::Lang::Variable.new(*args)
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

  describe '#to_s' do
    it "includes just the variable name when there's no value" do
      var('$').to_s.should == 'MTK::Lang::Variable<$>'
    end

    it "includes just the variable name and value when there's a value" do
      var('x',1).to_s.should == 'MTK::Lang::Variable<x=1>'
    end
  end

end
