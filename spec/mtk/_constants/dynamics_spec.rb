require 'spec_helper'
  
describe MTK::Dynamics do

  describe 'ppp' do
    it 'is equivalent to MIDI velocity 16' do
      (ppp * 127).round.should == 16
    end
    it 'is available via a module property and via mixin' do
      Dynamics::ppp.should == ppp
    end
  end

  describe 'pp' do
    it 'is equivalent to MIDI velocity 32' do
      (pp * 127).round.should == 32
    end
    it 'is available via a module property and via mixin' do
      Dynamics::pp.should == pp
    end    
  end

  describe 'p' do
    it 'is equivalent to MIDI velocity 48' do
      (p * 127).round.should == 48
    end
    it 'is available via a module property and via mixin' do
      Dynamics::p.should == p
    end    
  end

  describe 'mp' do
    it 'is equivalent to MIDI velocity 64' do
      (mp * 127).round.should == 64
    end
    it 'is available via a module property and via mixin' do
      Dynamics::mp.should == mp
    end    
  end

  describe 'mf' do
    it 'is equivalent to MIDI velocity 79' do
      (mf * 127).round.should == 79
    end
    it 'is available via a module property and via mixin' do
      Dynamics::mf.should == mf
    end    
  end

  describe 'f' do
    it 'is equivalent to MIDI velocity 95' do
      (f * 127).round.should == 95
    end
    it 'is available via a module property and via mixin' do
      Dynamics::f.should == f
    end
    it "does not overwrite the PitchClass constant 'F'" do
      F.should be_a PitchClass
    end    
  end

  describe 'ff' do
    it 'is equivalent to MIDI velocity 111' do
      (ff * 127).round.should == 111
    end
    it 'is available via a module property and via mixin' do
      Dynamics::ff.should == ff
    end
  end

  describe 'fff' do
    it 'is equivalent to MIDI velocity 127' do
      (fff * 127).round.should == 127
    end
    it 'is available via a module property and via mixin' do
      Dynamics::fff.should == fff
    end
  end

  describe ".[]" do
    it "looks up the constant by name" do
      Dynamics['ppp'].should == ppp
      Dynamics['pp'].should == pp
      Dynamics['p'].should == p
      Dynamics['mp'].should == mp
      Dynamics['mf'].should == mf
      Dynamics['f'].should == f
      Dynamics['ff'].should == ff
      Dynamics['fff'].should == fff
    end
  end

  describe "DYNAMICS" do
    it "contains all dynamics pseudo-constants" do
      Dynamics::DYNAMICS.should =~ [ppp, pp, p, mp, mf, f, ff, fff]
    end

    it "is immutable" do
      lambda{ Dynamics::DYNAMICS << :something }.should raise_error
    end
  end

end
  
