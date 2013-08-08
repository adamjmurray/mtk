require 'spec_helper'

describe MTK::Lang::Variable do

  VARIABLE = MTK::Lang::Variable

  def var(*args)
    VARIABLE.new(*args)
  end


  describe '.define_arpeggio' do
    it 'defines a variable where #arppegio? is true' do
      VARIABLE.define_arpeggio(nil).arpeggio?.should be_true
    end

    it 'has a #value of the given argument' do
      VARIABLE.define_arpeggio(:arp_stuff).value.should == :arp_stuff
    end
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


  describe '#implicit?' do
    it 'is true when the variable name is $' do
      var('$').implicit?.should be_true
    end

    it 'is true when the variable name is any number of $ characters' do
      10.times{|i| var('$'*(i+1)).implicit?.should be_true }
    end

    it 'is false otherwise' do
      var('x').implicit?.should be_false
      var('$x').implicit?.should be_false
      var('$1').implicit?.should be_false
    end
  end


  describe '#arpeggio?' do
    it 'is true when a variable has the name Variable::ARPEGGIO' do
      VARIABLE.new(VARIABLE::ARPEGGIO, nil).arpeggio?.should be_true
    end

    it 'is false otherwise' do
      var('x').arpeggio?.should be_false
      var('$x').arpeggio?.should be_false
      var('$').arpeggio?.should be_false
      var('$$').arpeggio?.should be_false
    end
  end


  describe '#arpeggio_index?' do
    it 'is true when the variable name is $N where N is a natural number' do
      var('$1').arpeggio_index?.should be_true
      var('$1023456987').arpeggio_index?.should be_true
    end

    it 'is false otherwise' do
      var('x').arpeggio_index?.should be_false
      var('$x').arpeggio_index?.should be_false
      var('$').arpeggio_index?.should be_false
      var('$$').arpeggio_index?.should be_false
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
