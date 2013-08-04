require 'spec_helper'
  
describe MTK::Lang::Intensities do

  describe 'ppp' do
    it 'is equivalent to MIDI velocity 16' do
      (ppp.value * 127).round.should == 16
    end
    it 'is available via a module property and via mixin' do
      Intensities::ppp.should == ppp
    end
  end

  describe 'pp' do
    it 'is equivalent to MIDI velocity 32' do
      (pp.value * 127).round.should == 32
    end
    it 'is available via a module property and via mixin' do
      Intensities::pp.should == pp
    end    
  end

  describe 'p' do
    it 'is equivalent to MIDI velocity 48' do
      (p.value * 127).round.should == 48
    end
    it 'is available via a module property and via mixin' do
      Intensities::p.should == p
    end    
  end

  describe 'mp' do
    it 'is equivalent to MIDI velocity 64' do
      (mp.value * 127).round.should == 64
    end
    it 'is available via a module property and via mixin' do
      Intensities::mp.should == mp
    end    
  end

  describe 'mf' do
    it 'is equivalent to MIDI velocity 79' do
      (mf.value * 127).round.should == 79
    end
    it 'is available via a module property and via mixin' do
      Intensities::mf.should == mf
    end    
  end

  describe 'f' do # AKA forte
    it 'is equivalent to MIDI velocity 95' do
      (f.value * 127).round.should == 95
    end
    it 'is available via a module property and via mixin' do
      Intensities::f.should == f
    end
    it "does not overwrite the PitchClass constant 'F'" do
      F.should be_a PitchClass
    end    
  end

  describe 'ff' do
    it 'is equivalent to MIDI velocity 111' do
      (ff.value * 127).round.should == 111
    end
    it 'is available via a module property and via mixin' do
      Intensities::ff.should == ff
    end
  end

  describe 'fff' do
    it 'is equivalent to MIDI velocity 127' do
      (fff.value * 127).round.should == 127
    end
    it 'is available via a module property and via mixin' do
      Intensities::fff.should == fff
    end
  end

  describe "INTENSITIES" do
    it "contains all Intensities pseudo-constants" do
      Intensities::INTENSITIES.should =~ [ppp, pp, p, mp, mf, f, ff, fff]
    end

    it "is immutable" do
      lambda{ Intensities::INTENSITIES << :something }.should raise_error
    end
  end

  describe "INTENSITY_NAMES" do
    it "contains all Intensities pseudo-constants names as strings" do
      Intensities::INTENSITY_NAMES.should =~ ['ppp', 'pp', 'p', 'mp', 'mf', 'f', 'ff', 'fff']
    end

    it "is immutable" do
      lambda{ Intensities::INTENSITY_NAMES << :something }.should raise_error
    end
  end

end
  
