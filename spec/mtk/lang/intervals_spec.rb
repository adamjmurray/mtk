require 'spec_helper'
  
describe MTK::Lang::Intervals do

  describe 'P1' do
    it 'is 0 semitones' do
      P1.should == Interval[0]
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'd2' do
    it 'is 0 semitones' do
      d2.should == Interval[0]
    end
    it 'is available via a module property and via mixin' do
      Intervals::d2.should == d2
    end
  end

  describe 'm2' do
    it 'is 1 semitone' do
      m2.should == Interval[1]
    end
    it 'is available via a module property and via mixin' do
      Intervals::m2.should == m2
    end
  end

  describe 'a1' do
    it 'is 1 semitone' do
      a1.should == Interval[1]
    end
    it 'is available via a module property and via mixin' do
      Intervals::a1.should == a1
    end
  end

  describe 'M2' do
    it 'is 2 semitones' do
      M2.should == Interval[2]
    end
    it 'is available via a module property and via mixin' do
      Intervals::M2.should == M2
    end
  end

  describe 'd3' do
    it 'is 2 semitones' do
      d3.should == Interval[2]
    end
    it 'is available via a module property and via mixin' do
      Intervals::d3.should == d3
    end
  end

  describe 'm3' do
    it 'is 3 semitones' do
      m3.should == Interval[3]
    end
    it 'is available via a module property and via mixin' do
      Intervals::m3.should == m3
    end
  end

  describe 'a2' do
    it 'is 3 semitones' do
      a2.should == Interval[3]
    end
    it 'is available via a module property and via mixin' do
      Intervals::a2.should == a2
    end
  end

  describe 'M3' do
    it 'is 4 semitones' do
      M3.should == Interval[4]
    end
    it 'is available via a module property and via mixin' do
      Intervals::M3.should == M3
    end
  end

  describe 'd4' do
    it 'is 4 semitones' do
      d4.should == Interval[4]
    end
    it 'is available via a module property and via mixin' do
      Intervals::d4.should == d4
    end
  end

  describe 'P4' do
    it 'is 5 semitones' do
      P4.should == Interval[5]
    end
    it 'is available via a module property and via mixin' do
      Intervals::P4.should == P4
    end
  end

  describe 'a3' do
    it 'is 5 semitones' do
      a3.should == Interval[5]
    end
    it 'is available via a module property and via mixin' do
      Intervals::a3.should == a3
    end
  end

  describe 'TT' do
    it 'is 6 semitones' do
      TT.should == Interval[6]
    end
    it 'is available via a module property and via mixin' do
      Intervals::TT.should == TT
    end
  end

  describe 'a4' do
    it 'is 6 semitones' do
      a4.should == Interval[6]
    end
    it 'is available via a module property and via mixin' do
      Intervals::a4.should == a4
    end
  end

  describe 'd5' do
    it 'is 6 semitones' do
      d5.should == Interval[6]
    end
    it 'is available via a module property and via mixin' do
      Intervals::d5.should == d5
    end
  end

  describe 'P5' do
    it 'is 7 semitones' do
      P5.should == Interval[7]
    end
    it 'is available via a module property and via mixin' do
      Intervals::P5.should == P5
    end
  end

  describe 'd6' do
    it 'is 7 semitones' do
      d6.should == Interval[7]
    end
    it 'is available via a module property and via mixin' do
      Intervals::d6.should == d6
    end
  end

  describe 'm6' do
    it 'is 8 semitones' do
      m6.should == Interval[8]
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'a5' do
    it 'is 8 semitones' do
      a5.should == Interval[8]
    end
    it 'is available via a module property and via mixin' do
      Intervals::a5.should == a5
    end
  end

  describe 'M6' do
    it 'is 9 semitones' do
      M6.should == Interval[9]
    end
    it 'is available via a module property and via mixin' do
      Intervals::M6.should == M6
    end
  end

  describe 'd7' do
    it 'is 9 semitones' do
      d7.should == Interval[9]
    end
    it 'is available via a module property and via mixin' do
      Intervals::d7.should == d7
    end
  end

  describe 'm7' do
    it 'is 10 semitones' do
      m7.should == Interval[10]
    end
    it 'is available via a module property and via mixin' do
      Intervals::m7.should == m7
    end
  end

  describe 'a6' do
    it 'is 10 semitones' do
      a6.should == Interval[10]
    end
    it 'is available via a module property and via mixin' do
      Intervals::a6.should == a6
    end
  end

  describe 'M7' do
    it 'is 11 semitones' do
      M7.should == Interval[11]
    end
    it 'is available via a module property and via mixin' do
      Intervals::M7.should == M7
    end
  end

  describe 'd8' do
    it 'is 11 semitones' do
      d8.should == Interval[11]
    end
    it 'is available via a module property and via mixin' do
      Intervals::d8.should == d8
    end
  end

  describe 'P8' do
    it 'is 12 semitones' do
      P8.should == Interval[12]
    end
    it 'is available via a module property and via mixin' do
      Intervals::P8.should == P8
    end
  end

  describe 'a7' do
    it 'is 12 semitones' do
      a7.should == Interval[12]
    end
    it 'is available via a module property and via mixin' do
      Intervals::a7.should == a7
    end
  end


  describe "INTERVALS" do
    it "contains all intervals constants/pseudo-constants" do
      Intervals::INTERVALS.should =~ MTK::Core::Interval::ALL_NAMES.map{|name| MTK::Core::Interval.from_name(name) }
    end

    it "is immutable" do
      lambda{ Intervals::INTERVALS << :something }.should raise_error
    end
  end

  describe "INTERVAL_NAMES" do
    it "contains all intervals constants/pseudo-constant names" do
      Intervals::INTERVAL_NAMES.should =~ MTK::Core::Interval::ALL_NAMES
    end

    it "is immutable" do
      lambda{ Intervals::INTERVAL_NAMES << :something }.should raise_error
    end
  end

end
