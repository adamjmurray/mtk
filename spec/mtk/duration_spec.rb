require 'spec_helper'

describe MTK::Duration do

  let(:one_beat)  { Duration[1] }
  let(:two_beats) { Duration[2] }


  describe 'NAMES' do
    it "is the list of base duration names available" do
      Duration::NAMES.should =~ %w( w h q i s r x )
    end

    it "is immutable" do
      lambda{ Duration::NAMES << 'z' }.should raise_error
    end
  end


  describe 'VALUES_BY_NAME' do
    it 'maps names to values' do
      Duration::VALUES_BY_NAME.each do |name,value|
        Duration.from_s(name).value.should == value
      end
    end

    it 'is immutable' do
      lambda{ Duration::VALUES_BY_NAME << 'z' }.should raise_error
    end
  end


  describe '.new' do
    it "constructs a Duration with whatever value is given" do
      float = 0.5
      value = Duration.new(float).value
      value.should be_equal float
    end
  end


  describe '.[]' do
    it "constructs and caches a duration from a Numeric" do
      Duration[1].should be_equal Duration[1]
    end

    it "retains the new() method's ability to construct uncached objects" do
      Duration.new(1).should_not be_equal Duration[1]
    end

    it "uses the argument as the value, if the argument is a Fixnum" do
      value = Duration[4].value
      value.should be_equal 4
    end

    it "converts other Numerics to Rational values" do
      value = Duration[0.5].value
      value.should be_a Rational
      value.should == Rational(1,2)
    end
  end


  describe '.from_i' do
    it "uses the argument as the value" do
      value = Duration.from_i(4).value
      value.should be_equal 4
    end
  end

  describe '.from_f' do
    it "converts Floats to Rational" do
      value = Duration.from_i(0.5).value
      value.should be_a Rational
      value.should == Rational(1,2)
    end
  end

  describe '.from_s' do
    it "converts any of the duration NAMES into a Duration with the value from the VALUES_BY_NAME mapping" do
      for name in Duration::NAMES
        Duration.from_s(name).value.should == Duration::VALUES_BY_NAME[name]
      end
    end
  end

  describe '.from_name' do
    it "acts like .from_s" do
      for name in Duration::NAMES
        Duration.from_name(name).value.should == Duration::VALUES_BY_NAME[name]
      end
    end
  end


  describe '#value' do
    it "is the value used to construct the Duration" do
      Duration.new(1.111).value.should == 1.111
    end
  end


  describe '#to_f' do
    it "is the value as a floating point number" do
      f = Duration.new(Rational(1,2)).to_f
      f.should be_a Float
      f.should == 0.5
    end
  end

  describe '#to_i' do
    it "is the value rounded to the nearest integer" do
      i = Duration.new(0.5).to_i
      i.should be_a Fixnum
      i.should == 1
      Duration.new(0.49).to_i.should == 0
    end
  end

  describe '#to_s' do
    it "should be value.to_s" do
      for value in [1, Rational(1,2), 0.25]
        Duration.new(value).to_s.should == value.to_s
      end
    end
  end

  describe '#==' do
    it "compares two duration values for equality" do
      Duration.new(Rational(1,2)).should == Duration.new(0.5)
      Duration.new(4).should == Duration.new(4)
      Duration.new(1.1).should_not == Duration.new(1)
    end
  end

  describe "#<=>" do
    it "orders durations based on their underlying value" do
      ( Duration.new(1) <=> Duration.new(1.1) ).should < 0
      ( Duration.new(2) <=> Duration.new(1) ).should > 0
      ( Duration.new(1.0) <=> Duration.new(1) ).should == 0
    end
  end



  describe '#+' do
    it 'adds #value to the Numeric argument' do
      (one_beat + 1.5).should == Duration[2.5]
    end

    it 'works with a Duration argument' do
      (one_beat + Duration[1.5]).should == Duration[2.5]
    end

    it 'returns a new duration (Duration is immutable)' do
      original = one_beat
      modified = one_beat + 2
      original.should_not == modified
      original.should == Duration[1]
    end
  end

  describe '#-' do
    it 'subtract the Numeric argument from #value' do
      (one_beat - 0.5).should == Duration[0.5]
    end

    it 'works with a Duration argument' do
      (one_beat - Duration[0.5]).should == Duration[0.5]
    end

    it 'returns a new duration (Duration is immutable)' do
      original = one_beat
      modified = one_beat - 0.5
      original.should_not == modified
      original.should == Duration[1]
    end
  end


  describe '#*' do
    it 'multiplies #value to the Numeric argument' do
      (two_beats * 3).should == Duration[6]
    end

    it 'works with a Duration argument' do
      (two_beats * Duration[3]).should == Duration[6]
    end

    it 'returns a new duration (Duration is immutable)' do
      original = one_beat
      modified = one_beat * 2
      original.should_not == modified
      original.should == Duration[1]
    end
  end

  describe '#/' do
    it 'divides #value by the Numeric argument' do
      (two_beats / 4.0).should == Duration[0.5]
    end

    it 'works with a Duration argument' do
      (two_beats / Duration[4]).should == Duration[0.5]
    end

    it 'returns a new duration (Duration is immutable)' do
      original = one_beat
      modified = one_beat / 2
      original.should_not == modified
      original.should == Duration[1]
    end
  end

  describe '#coerce' do
    it 'allows a Duration to be added to a Numeric' do
      (2 + one_beat).should == Duration[3]
    end

    it 'allows a Duration to be subtracted from a Numeric' do
      (7 - two_beats).should == Duration[5]
    end

    it 'allows a Duration to be multiplied to a Numeric' do
      (3 * two_beats).should == Duration[6]
    end

    it 'allows a Numeric to be divided by a Duration' do
      (8.0 / two_beats).should == Duration[4]
    end
  end

end

describe MTK do

  describe '#Duration' do
    it "acts like .from_s if the argument is a String" do
      Duration('w').should == Duration.from_s('w')
    end

    it "acts like .from_s if the argument is a Symbol" do
      Duration(:w).should == Duration.from_s('w')
    end

    it "acts like .[] if the argument is a Numeric" do
      Duration(3.5).should be_equal Duration[Rational(7,2)]
    end

    it "returns the argument if it's already a Duration" do
      Duration(Duration[1]).should be_equal Duration[1]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Duration({:not => :compatible}) }.should raise_error
    end
  end

end
