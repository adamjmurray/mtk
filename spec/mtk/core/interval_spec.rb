require 'spec_helper'

describe MTK::Core::Interval do

  let(:minor_second)  { Interval[1] }


  describe 'NAMES' do
    it "is the list of base interval names available" do
      Interval::NAMES.should =~ %w( P1 m2 M2 m3 M3 P4 TT P5 m6 M6 m7 M7 P8 )
    end

    it "is immutable" do
      lambda{ Interval::NAMES << 'z' }.should raise_error
    end
  end


  describe 'VALUES_BY_NAME' do
    it 'maps names to values' do
      Interval::VALUES_BY_NAME.each do |name,value|
        Interval.from_s(name).value.should == value
      end
    end

    it 'is immutable' do
      lambda{ Interval::VALUES_BY_NAME << 'z' }.should raise_error
    end
  end


  describe 'ALL_NAMES' do
    it 'contains all NAMES' do
      Interval::NAMES.each{|name| Interval::ALL_NAMES.should include name }
    end
  end


  describe '.new' do
    it "constructs a Interval with whatever value is given" do
      float = 0.5
      value = Interval.new(float).value
      value.should be_equal float
    end
  end


  describe '.[]' do
    it "constructs and caches a interval from a Numeric" do
      Interval[1].should be_equal Interval[1]
    end

    it "retains the new() method's ability to construct uncached objects" do
      Interval.new(1).should_not be_equal Interval[1]
    end

    it "converts the value to floating point" do
      value = Interval[Rational(1,2)].value
      value.should be_a Float
      value.should == 0.5
    end

  end


  describe '.from_i' do
    it "acts like .[]" do
      Interval.from_i(0).value.should == 0.0
      Interval.from_i(4).value.should == 4.0
    end
  end

  describe '.from_f' do
    it "acts like .[]" do
      value = Interval.from_f(Rational(1,2)).value
      value.should be_a Float
      value.should == 0.5
    end
  end

  describe '.from_s' do
    it "converts any of the interval NAMES into a Interval with the value from the VALUES_BY_NAME mapping" do
      for name in Interval::ALL_NAMES
        Interval.from_s(name).value.should == Interval::VALUES_BY_NAME[name]
      end
    end

    it "converts any of the interval NAMES into a Interval with a negative value when it starts with '-'" do
      for name in Interval::ALL_NAMES
        Interval.from_s("-#{name}").value.should == -Interval::VALUES_BY_NAME[name]
      end
    end
  end

  describe '.from_name' do
    it "acts like .from_s" do
      for name in Interval::NAMES
        Interval.from_name(name).value.should == Interval::VALUES_BY_NAME[name]
      end
    end
  end


  describe '#value' do
    it "is the value used to construct the Interval" do
      Interval.new(1.111).value.should == 1.111
    end
  end


  describe '#to_f' do
    it "is the value as a floating point number" do
      f = Interval.new(Rational(1,2)).to_f
      f.should be_a Float
      f.should == 0.5
    end
  end

  describe '#to_i' do
    it "is the value rounded to the nearest integer" do
      i = Interval.new(0.5).to_i
      i.should be_a Fixnum
      i.should == 1
      Interval.new(0.49).to_i.should == 0
    end
  end

  describe '#to_s' do
    it "should be value.to_s" do
      for value in [1, Rational(1,2), 0.25]
        Interval.new(value).to_s.should == value.to_s
      end
    end
  end

  describe '#==' do
    it "compares two interval values for equality" do
      Interval.new(Rational(1,2)).should == Interval.new(0.5)
      Interval.new(4).should == Interval.new(4)
      Interval.new(1.1).should_not == Interval.new(1)
    end
  end

  describe "#<=>" do
    it "orders intervals based on their underlying value" do
      ( Interval.new(1) <=> Interval.new(1.1) ).should < 0
      ( Interval.new(2) <=> Interval.new(1) ).should > 0
      ( Interval.new(1.0) <=> Interval.new(1) ).should == 0
    end
  end



  describe '#+' do
    it 'adds #value to the Numeric argument' do
      (minor_second + 0.25).should == Interval[1.25]
    end

    it 'works with an Interval argument' do
      (minor_second + Interval[0.25]).should == Interval[1.25]
    end

    it 'returns a new interval (Interval is immutable)' do
      original = minor_second
      modified = minor_second + 0.25
      original.should_not == modified
      original.should == Interval[1]
    end
  end

  describe '#-' do
    it 'subtract the Numeric argument from #value' do
      (minor_second - 0.25).should == Interval[0.75]
    end

    it 'works with a Interval argument' do
      (minor_second - Interval[0.25]).should == Interval[0.75]
    end

    it 'returns a new interval (Interval is immutable)' do
      original = minor_second
      modified = minor_second - 0.25
      original.should_not == modified
      original.should == Interval[1]
    end
  end


  describe '#*' do
    it 'multiplies #value to the Numeric argument' do
      (minor_second * 3).should == Interval[3]
    end

    it 'works with a Interval argument' do
      (minor_second * Interval[3]).should == Interval[3]
    end

    it 'returns a new interval (Interval is immutable)' do
      original = minor_second
      modified = minor_second * 2
      original.should_not == modified
      original.should == Interval[1]
    end
  end

  describe '#/' do
    it 'divides #value by the Numeric argument' do
      (minor_second / 2).should == Interval[0.5]
    end

    it 'works with a Interval argument' do
      (minor_second / Interval[2]).should == Interval[0.5]
    end

    it 'returns a new interval (Interval is immutable)' do
      original = minor_second
      modified = minor_second / 2
      original.should_not == modified
      original.should == Interval[1]
    end
  end

  describe '-@' do
    it "multiplies the interval by -1" do
      (-minor_second).should == minor_second * -1
    end
  end

  describe '#coerce' do
    it 'allows a Interval to be added to a Numeric' do
      (0.25 + minor_second).should == Interval[1.25]
    end

    it 'allows a Interval to be subtracted from a Numeric' do
      (3 - minor_second).should == Interval[2]
    end

    it 'allows a Interval to be multiplied to a Numeric' do
      (3 * minor_second).should == Interval[3]
    end

    it 'allows a Numeric to be divided by a Interval' do
      (4 / minor_second).should == Interval[4]
    end
  end

end

describe MTK do

  describe '#Interval' do
    it "acts like .from_s if the argument is a String" do
      for name in Interval::ALL_NAMES
        Interval(name).should == Interval.from_s(name)
      end
    end

    it "acts like .from_s if the argument is a Symbol" do
      for name in Interval::ALL_NAMES
        Interval(name.to_sym).should == Interval.from_s(name)
      end
    end

    it "acts like .[] if the argument is a Numeric" do
      Interval(0.5).should be_equal Interval[0.5]
    end

    it "returns the argument if it's already a Interval" do
      Interval(Interval[1]).should be_equal Interval[1]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Interval({:not => :compatible}) }.should raise_error
    end
  end

end
