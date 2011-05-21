require 'spec_helper'

describe MTK::Pitches do

  it "defines constants for the 128 notes in MIDI" do
    Pitches.constants.length.should == 129 # there's also the PITCHES constant
    Pitches::C_1.should == Pitch.from_s('C-1')
    Pitches::D0.should == Pitch.from_s('D0')
    Pitches::Eb1.should == Pitch.from_s('Eb1')
    Pitches::G9.should == Pitch.from_s('g9')
  end

  describe "PITCHES" do
    it "contains all 128 pitch constants" do
      Pitches::PITCHES.length.should == 128
      Pitches::PITCHES.should include Pitches::C_1
      Pitches::PITCHES.should include Pitches::D0
      Pitches::PITCHES.should include Pitches::Eb1
      Pitches::PITCHES.should include Pitches::G9
    end
  end

end
