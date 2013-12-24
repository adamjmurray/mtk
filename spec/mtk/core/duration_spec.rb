require 'spec_helper'

describe MTK::Core::Duration do

  let(:one_beat)  { Duration[1] }
  let(:two_beats) { Duration[2] }


  describe 'NAMES' do
    it "is the list of base duration names available" do
      Duration::NAMES.should =~ %w( w h q e s r x )
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


  describe 'DOTTED' do
    it 'is the multiplier 3/2' do
      MTK::Core::Duration::DOTTED.should == Rational(3,2)
    end
  end

  describe 'TRIPLET' do
    it 'is the multiplier 2/3' do
      MTK::Core::Duration::TRIPLET.should == Rational(2,3)
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
  end


  describe '.from_i' do
    it "uses the argument as the value" do
      value = Duration.from_i(4).value
      value.should be_equal 4
    end
  end

  describe '.from_f' do
    it "uses the argument as the value" do
      value = Duration.from_f(0.5).value
      value.should be_a Float
      value.should == 0.5
    end
  end

  describe '.from_s' do
    it "converts any of the duration NAMES into a Duration with the value from the VALUES_BY_NAME mapping" do
      for name in Duration::NAMES
        Duration.from_s(name).value.should == Duration::VALUES_BY_NAME[name]
      end
    end

    it "converts any of the duration names prefixed with a '-' to the negative value" do
      for name in Duration::NAMES
        Duration.from_s("-#{name}").value.should == -1 * Duration::VALUES_BY_NAME[name]
      end
    end

    it "converts any of the duration names suffixed a 't' to 2/3 of the value" do
      for name in Duration::NAMES
        Duration.from_s("#{name}t").value.should == Rational(2,3) * Duration::VALUES_BY_NAME[name]
      end
    end

    it "converts any of the duration names suffixed a '.' to 3/2 of the value" do
      for name in Duration::NAMES
        Duration.from_s("#{name}.").value.should == Rational(3,2) * Duration::VALUES_BY_NAME[name]
      end
    end

    it "converts suffix combinations of 't' and '.' (multiplying by 2/3 and 3/2 for each)" do
      trip = Rational(2,3)
      dot  = Rational(3,2)
      for name in Duration::NAMES
        for suffix,multiplier in {'tt' => trip*trip, 't.' => trip*dot, '..' => dot*dot, 't..t.' => trip*dot*dot*trip*dot}
          Duration.from_s("#{name}#{suffix}").value.should == multiplier * Duration::VALUES_BY_NAME[name]
        end
      end
    end

    it "parses durations with integer multipliers" do
      Durations::DURATION_NAMES.each_with_index do |duration, index|
        multiplier = index+5
        Duration.from_s("#{multiplier}#{duration}").should == multiplier * Duration(duration)
      end
    end

    it "parses durations with float multipliers" do
      Durations::DURATION_NAMES.each_with_index do |duration, index|
        multiplier = (index+1)*1.123
        Duration.from_s("#{multiplier}#{duration}").should == multiplier * Duration(duration)
      end
    end

    it "parses durations with float multipliers" do
      Durations::DURATION_NAMES.each_with_index do |duration, index|
        multiplier = Rational(index+1, index+2)
        Duration.from_s("#{multiplier}#{duration}").should == multiplier * Duration(duration)
      end
    end

    it "parses combinations of all modifiers" do
      Duration.from_s("-4/5qt.").value.should == -4.0/5 * 1 * 2/3.0 * 3/2.0
      Duration.from_s("-11.234h.tt").value.should == 2 * 3/2.0 * 2/3.0 * 2/3.0 * -11.234
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


  describe '#length' do
    it 'is the value for positive values' do
      Duration.new(4).length.should == 4
    end

    it 'is the absolute value for negative values' do
      Duration.new(-4).length.should == 4
    end
  end


  describe '#rest?' do
    it 'is false for positive values' do
      Duration.new(4).rest?.should be_false
    end

    it 'is true for negative values' do
      Duration.new(-4).rest?.should be_true
    end
  end


  describe '#abs' do
    it 'returns the Duration is the value is positive' do
      d = MTK.Duration(2)
      d.abs.should be d
    end

    it 'returns the negation of the Duration is the value is negative' do
      d = MTK.Duration(-2)
      d.abs.should == -d
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
    it "is value.to_s suffixed with 'beats' for beat values > 1" do
      for value in [2, Rational(3,2), Rational(3.25)]
        Duration.new(value).to_s.should == value.to_s + ' beats'
      end
    end

    it "is value.to_s suffixed with 'beats' for positive, non-zero beat values < 1" do
      for value in [Rational(1,2), Rational(0.25)]
        Duration.new(value).to_s.should == value.to_s + ' beat'
      end
    end

    it "is value.to_s suffixed with 'beats' for a value of 0" do
      Duration.new(0).to_s.should == '0 beats'
    end

    it "is value.to_s suffixed with 'beats' for beat values < -1" do
      for value in [-2, -Rational(3,2), Rational(-3.25)]
        Duration.new(value).to_s.should == value.to_s + ' beats'
      end
    end

    it "is value.to_s suffixed with 'beat' for negative, non-zero beat values > -1" do
      for value in [-Rational(1,2), Rational(-0.25)]
        Duration.new(value).to_s.should == value.to_s + ' beat'
      end
    end
    
    it "rounds to 2 decimal places when value.to_s is overly long" do
      Duration.new(Math.sqrt 2).to_s.should == '1.41 beats'
    end

    it "drops unnecessary decimal places" do
      Duration.new(1.0).to_s.should == '1 beat'
    end

    it "drops unnecessary denominators" do
      Duration.new(Rational(2,1)).to_s.should == '2 beats'
    end

    it "converts floats when long string reprentations to simple fractions when possible" do
      Duration.new(1/3.0).to_s.should == '1/3 beat'
    end

    it "keeps floats with short string representations as floats" do
      Duration.new(3.25).to_s.should == '3.25 beats'
    end
  end

  describe '#inspect' do
    it 'is "#<MTK::Core::Duration:{object_id} @value={value}>"' do
      for value in [0, 60, 60.5, 127]
        duration = Duration.new(value)
        duration.inspect.should == "#<MTK::Core::Duration:#{duration.object_id} @value=#{value}>"
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

  describe '-@' do
    it "multiplies the duration by -1" do
      (-one_beat).should == one_beat * -1
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
      Duration(3.5).should be_equal Duration[3.5]
    end

    it "returns the argument if it's already a Duration" do
      Duration(Duration[1]).should be_equal Duration[1]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Duration({:not => :compatible}) }.should raise_error
    end
  end

end
