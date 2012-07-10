require 'spec_helper'
  
describe MTK::Constants::Intervals do

  describe 'P1' do
    it 'is 0 semitones' do
      P1.should == 0
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'm2' do
    it 'is 1 semitone' do
      m2.should == 1
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'M2' do
    it 'is 2 semitones' do
      M2.should == 2
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'm3' do
    it 'is 3 semitones' do
      m3.should == 3
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'M3' do
    it 'is 4 semitones' do
      M3.should == 4
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'P4' do
    it 'is 5 semitones' do
      P4.should == 5
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'TT' do
    it 'is 6 semitones' do
      TT.should == 6
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'P5' do
    it 'is 7 semitones' do
      P5.should == 7
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'm6' do
    it 'is 8 semitones' do
      m6.should == 8
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'M6' do
    it 'is 9 semitones' do
      M6.should == 9
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'm7' do
    it 'is 10 semitones' do
      m7.should == 10
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'M7' do
    it 'is 11 semitones' do
      M7.should == 11
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end

  describe 'P8' do
    it 'is 12 semitones' do
      P8.should == 12
    end
    it 'is available via a module property and via mixin' do
      Intervals::P1.should == P1
    end
  end


  describe "INTERVALS" do
    it "contains all intervals constants/pseudo-constants" do
      Intervals::INTERVALS.should =~ [P1, m2, M2, m3, M3, P4, TT, P5, m6, M6, m7, M7, P8]
    end

    it "is immutable" do
      lambda{ Intervals::INTERVALS << :something }.should raise_error
    end
  end

  describe "INTERVAL_NAMES" do
    it "contains all intervals constants/pseudo-constant names" do
      Intervals::INTERVAL_NAMES.should =~ ['P1', 'm2', 'M2', 'm3', 'M3', 'P4', 'TT', 'P5', 'm6', 'M6', 'm7', 'M7', 'P8']
    end

    it "is immutable" do
      lambda{ Intervals::INTERVAL_NAMES << :something }.should raise_error
    end
  end

  describe ".[]" do
    it "looks up the constant by name" do
      Intervals['P1'].should == P1
      Intervals['m2'].should == m2
      Intervals['M2'].should == M2
      Intervals['m3'].should == m3
      Intervals['M3'].should == M3
      Intervals['P4'].should == P4
      Intervals['TT'].should == TT
      Intervals['P5'].should == P5
      Intervals['m6'].should == m6
      Intervals['M6'].should == M6
      Intervals['m7'].should == m7
      Intervals['M7'].should == M7
      Intervals['P8'].should == P8
    end

    it "returns nil for arguments it doesn't understand" do
      Intervals[:invalid].should be_nil
    end
  end

end
