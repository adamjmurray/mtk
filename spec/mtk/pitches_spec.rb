require 'spec_helper'

describe MTK::Pitches do  
  include Pitches

  it "defines constants for the 128 notes in MIDI" do
    Pitches.constants.length.should > 128 # there's also the MIDI_PITCHES constant
    C_1.should == Frequency::Pitch.from_s('C-1')
    D0.should  == Frequency::Pitch.from_s('D0')
    Eb1.should == Frequency::Pitch.from_s('Eb1')
    G9.should  == Frequency::Pitch.from_s('g9')
  end

  describe "MIDI_PITCHES" do
    it "containts all 128 pitch constants" do
      MIDI_PITCHES.length.should == 128
      MIDI_PITCHES.should include C_1
      MIDI_PITCHES.should include D0
      MIDI_PITCHES.should include Eb1
      MIDI_PITCHES.should include G9                    
    end
  end

end
