require 'spec_helper'

describe MTK::Lang::Variable do

  VARIABLE = MTK::Lang::Variable

  def var(*args)
    VARIABLE.new(*args)
  end


  describe '#type' do
    it 'is the type the Variable was constructed with' do
      var(:type1, :foo).type.should == :type1
      var(:type2, :foo).type.should == :type2
    end

    it 'cannot be changed after the Variable is created' do
      lambda{ var(:type1, :foo).type = :type2 }.should raise_error
    end
  end

  describe '#name' do
    it 'is the name the Variable was constructed with' do
      var(:type, :x).name.should == :x
      var(:type, :y).name.should == :y
    end

    it 'cannot be changed after the Variable is created' do
      lambda{ var(:type, :x).name = :y }.should raise_error
    end
  end

  describe '#value' do
    it 'is the value the Variable was constructed with' do
      var(:name, :type, :value).value.should == :value
    end

    it 'can be changed after the Variable is created' do
      v = var(:name, :type, :value)
      v.value = 'foo'
      v.value.should == 'foo'
    end
  end

  describe '#scale?' do
    it 'is true when a Variable has the type Variable::SCALE' do
      var(VARIABLE::SCALE, :name).scale?.should be_true
    end

    it 'is false otherwise' do
      var(:type, :name).scale?.should be_false
    end
  end

  describe '#scale_element?' do
    it 'is true when the Variable has the type Variable::SCALE_ELEMENT' do
      var(VARIABLE::SCALE_ELEMENT, :name).scale_element?.should be_true
    end

    it 'is false otherwise' do
      var(:type, :name).scale_element?.should be_false
    end
  end

  describe '#arpeggio?' do
    it 'is true when a Variable has the type Variable::ARPEGGIO' do
      var(VARIABLE::ARPEGGIO, :name).arpeggio?.should be_true
    end

    it 'is false otherwise' do
      var(:type, :name).arpeggio?.should be_false
    end
  end

  describe '#arpeggio_element?' do
    it 'is true when the Variable has the type Variable::ARPEGGIO_ELEMENT' do
      var(VARIABLE::ARPEGGIO_ELEMENT, :name).arpeggio_element?.should be_true
    end

    it 'is false otherwise' do
      var(:type, :name).arpeggio_element?.should be_false
    end
  end

  describe '#for_each?' do
    it 'is true when the Variable has the type Variable::FOR_EACH' do
      var(VARIABLE::FOR_EACH, :name).for_each?.should be_true
    end

    it 'is false otherwise' do
      var(:type, :name).for_each?.should be_false
    end
  end

  describe '#user_defined?' do
    it 'is true when the Variable has the type Variable::USER_DEFINED' do
      var(VARIABLE::USER_DEFINED, :name).user_defined?.should be_true
    end

    it 'is false otherwise' do
      var(:type, :name).user_defined?.should be_false
    end
  end


  describe '#==' do
    it "is true when two variables' types, names, and values are equal" do
      var(:type, :name, :value).should == var(:type, :name, :value)
    end

    it "is false when two variables' types are not equal" do
      var(:type1, :name).should_not == var(:type2, :name)
    end

    it "is false when two variables' names are not equal" do
      var(:type, :name1).should_not == var(:type, :name2)
    end

    it "is false when two variables' values are not equal" do
      var(:type, :name, :val1).should_not == var(:type, :name, :val2)
    end
  end


  describe '#to_s' do
    it "includes just the variable type, name, and value" do
      var(VARIABLE::USER_DEFINED, :x, 1).to_s.should == 'MTK::Lang::Variable<user_defined x=1>'
    end

    it "clearly indicates String values" do
      var(VARIABLE::USER_DEFINED, :x, "foo").to_s.should == 'MTK::Lang::Variable<user_defined x="foo">'
    end

    it "clearly indicates nil values" do
      var(VARIABLE::USER_DEFINED, :x).to_s.should == 'MTK::Lang::Variable<user_defined x=nil>'
    end
  end

end
