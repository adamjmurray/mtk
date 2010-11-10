require 'spec_helper'
module Kreet
  module Pitches
    
    describe Pitches do
  
      it "defines constants for the 128 notes in MIDI" do
        Pitches.constants.length.should == (128 + 1) # there's also the PITCHES constant
        C_1.should == Pitch.new(PitchClasses::C,-1)
        D0.should == Pitch.new(PitchClasses::D,0)
        Eb1.should == Pitch.new(PitchClasses::Eb,1)
      end
    
      describe "PITCHES" do
        it "containts all 128 pitch constants" do
          PITCHES.length.should == 128
          PITCHES.should include C_1
          PITCHES.should include D0
          PITCHES.should include Eb1
          PITCHES.should include G9                    
        end
      end
    
    end
  end
end

