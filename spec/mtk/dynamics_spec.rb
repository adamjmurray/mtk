require 'spec_helper'

describe MTK::Dynamics do
  include Dynamics

  describe 'PPP' do
    it 'is equivalent to MIDI velocity 16' do
      (PPP * 127).round.should == 16
    end
  end

  describe 'PP' do
    it 'is equivalent to MIDI velocity 32' do
      (PP * 127).round.should == 32
    end
  end

  describe 'P' do
    it 'is equivalent to MIDI velocity 48' do
      (P * 127).round.should == 48
    end
  end

  describe 'MP' do
    it 'is equivalent to MIDI velocity 64' do
      (MP * 127).round.should == 64
    end
  end

  describe 'MF' do
    it 'is equivalent to MIDI velocity 79' do
      (MF * 127).round.should == 79
    end
  end

  describe 'F' do
    it 'is equivalent to MIDI velocity 95' do
      (F * 127).round.should == 95
    end
  end

  describe 'FF' do
    it 'is equivalent to MIDI velocity 111' do
      (FF * 127).round.should == 111
    end
  end

  describe 'FFF' do
    it 'is equivalent to MIDI velocity 127' do
      (FFF * 127).round.should == 127
    end
  end

end

