require 'spec_helper'

describe MTK::Intensity do

  let(:half_intensity)  { Intensity[0.5] }


  describe 'NAMES' do
    it "is the list of base intensity names available" do
      Intensity::NAMES.should =~ %w( ppp pp p mp mf o ff fff )
    end

    it "is immutable" do
      lambda{ Intensity::NAMES << 'z' }.should raise_error
    end
  end


  describe 'VALUES_BY_NAME' do
    it 'maps names to values' do
      Intensity::VALUES_BY_NAME.each do |name,value|
        Intensity.from_s(name).value.should == value
      end
    end

    it 'is immutable' do
      lambda{ Intensity::VALUES_BY_NAME << 'z' }.should raise_error
    end
  end


  describe '.new' do
    it "constructs a Intensity with whatever value is given" do
      float = 0.5
      value = Intensity.new(float).value
      value.should be_equal float
    end
  end


  describe '.[]' do
    it "constructs and caches a intensity from a Numeric" do
      Intensity[1].should be_equal Intensity[1]
    end

    it "retains the new() method's ability to construct uncached objects" do
      Intensity.new(1).should_not be_equal Intensity[1]
    end

    it "converts the value to floating point" do
      value = Intensity[Rational(1,2)].value
      value.should be_a Float
      value.should == 0.5
    end

  end


  describe '.from_i' do
    it "acts like .[]" do
      Intensity.from_i(0).value.should == 0.0
      Intensity.from_i(4).value.should == 4.0
    end
  end

  describe '.from_f' do
    it "acts like .[]" do
      value = Intensity.from_f(Rational(1,2)).value
      value.should be_a Float
      value.should == 0.5
    end
  end

  describe '.from_s' do
    it "converts any of the intensity NAMES into a Intensity with the value from the VALUES_BY_NAME mapping" do
      for name in Intensity::NAMES
        Intensity.from_s(name).value.should == Intensity::VALUES_BY_NAME[name]
      end
    end

    it "adds 1.0/24 when the name ends with '+', except for 'fff+' which is 1.0 like 'fff'" do
      for name in Intensity::NAMES
        if name == 'fff'
          Intensity.from_s("#{name}+").should == Intensity[1.0]
        else
          Intensity.from_s("#{name}+").should == Intensity[ Intensity::VALUES_BY_NAME[name] +1.0/24 ]
        end
      end
    end

    it "subtracts 1.0/24 when the name ends with '-'" do
      for name in Intensity::NAMES
        Intensity.from_s("#{name}-").should == Intensity[ Intensity::VALUES_BY_NAME[name] - 1.0/24 ]
      end
    end
  end

  describe '.from_name' do
    it "acts like .from_s" do
      for name in Intensity::NAMES
        Intensity.from_name(name).value.should == Intensity::VALUES_BY_NAME[name]
      end
    end
  end


  describe '#value' do
    it "is the value used to construct the Intensity" do
      Intensity.new(1.111).value.should == 1.111
    end
  end


  describe '#to_f' do
    it "is the value as a floating point number" do
      f = Intensity.new(Rational(1,2)).to_f
      f.should be_a Float
      f.should == 0.5
    end
  end

  describe '#to_i' do
    it "is the value rounded to the nearest integer" do
      i = Intensity.new(0.5).to_i
      i.should be_a Fixnum
      i.should == 1
      Intensity.new(0.49).to_i.should == 0
    end
  end

  describe '#to_s' do
    it "should be value.to_s" do
      for value in [1, Rational(1,2), 0.25]
        Intensity.new(value).to_s.should == value.to_s
      end
    end
  end

  describe '#==' do
    it "compares two intensity values for equality" do
      Intensity.new(Rational(1,2)).should == Intensity.new(0.5)
      Intensity.new(4).should == Intensity.new(4)
      Intensity.new(1.1).should_not == Intensity.new(1)
    end
  end

  describe "#<=>" do
    it "orders intensitys based on their underlying value" do
      ( Intensity.new(1) <=> Intensity.new(1.1) ).should < 0
      ( Intensity.new(2) <=> Intensity.new(1) ).should > 0
      ( Intensity.new(1.0) <=> Intensity.new(1) ).should == 0
    end
  end



  describe '#+' do
    it 'adds #value to the Numeric argument' do
      (half_intensity + 0.25).should == Intensity[0.75]
    end

    it 'works with an Intensity argument' do
      (half_intensity + Intensity[0.25]).should == Intensity[0.75]
    end

    it 'returns a new intensity (Intensity is immutable)' do
      original = half_intensity
      modified = half_intensity + 0.25
      original.should_not == modified
      original.should == Intensity[0.5]
    end
  end

  describe '#-' do
    it 'subtract the Numeric argument from #value' do
      (half_intensity - 0.25).should == Intensity[0.25]
    end

    it 'works with a Intensity argument' do
      (half_intensity - Intensity[0.25]).should == Intensity[0.25]
    end

    it 'returns a new intensity (Intensity is immutable)' do
      original = half_intensity
      modified = half_intensity - 0.25
      original.should_not == modified
      original.should == Intensity[0.5]
    end
  end


  describe '#*' do
    it 'multiplies #value to the Numeric argument' do
      (half_intensity * 0.1).should == Intensity[0.05]
    end

    it 'works with a Intensity argument' do
      (half_intensity * Intensity[0.1]).should == Intensity[0.05]
    end

    it 'returns a new intensity (Intensity is immutable)' do
      original = half_intensity
      modified = half_intensity * 2
      original.should_not == modified
      original.should == Intensity[0.5]
    end
  end

  describe '#/' do
    it 'divides #value by the Numeric argument' do
      (half_intensity / 2).should == Intensity[0.25]
    end

    it 'works with a Intensity argument' do
      (half_intensity / Intensity[0.5]).should == Intensity[1]
    end

    it 'returns a new intensity (Intensity is immutable)' do
      original = half_intensity
      modified = half_intensity / 2
      original.should_not == modified
      original.should == Intensity[0.5]
    end
  end

  describe '#coerce' do
    it 'allows a Intensity to be added to a Numeric' do
      (0.25 + half_intensity).should == Intensity[0.75]
    end

    it 'allows a Intensity to be subtracted from a Numeric' do
      (0.9 - half_intensity).should == Intensity[0.4]
    end

    it 'allows a Intensity to be multiplied to a Numeric' do
      (0.5 * half_intensity).should == Intensity[0.25]
    end

    it 'allows a Numeric to be divided by a Intensity' do
      (0.1 / half_intensity).should == Intensity[0.2]
    end
  end

end

describe MTK do

  describe '#Intensity' do
    it "acts like .from_s if the argument is a String" do
      Intensity('ppp').should == Intensity.from_s('ppp')
    end

    it "acts like .from_s if the argument is a Symbol" do
      Intensity(:ppp).should == Intensity.from_s('ppp')
    end

    it "acts like .[] if the argument is a Numeric" do
      Intensity(0.5).should be_equal Intensity[0.5]
    end

    it "returns the argument if it's already a Intensity" do
      Intensity(Intensity[1]).should be_equal Intensity[1]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Intensity({:not => :compatible}) }.should raise_error
    end
  end

end
