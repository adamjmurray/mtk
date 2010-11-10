require 'spec_helper'
module Kreet

  describe Pitch do

    let(:c) { PitchClasses::C }
    let(:g) { PitchClasses::G }
    let(:middle_c) { Pitch.new(c, 4) }
    let(:lowest)   { Pitch.new(c,-1) }
    let(:highest)  { Pitch.new(g, 9) }      

    describe '#pitch_class' do
      it "is the pitch class of the pitch" do
        middle_c.pitch_class.should == c
      end
    end

    describe '#octave' do
      it "is the octave of the pitch" do
        middle_c.octave.should == 4
      end
    end

    describe 'from_midi' do
      it "converts a midi note number to a Pitch" do
        Pitch.from_midi(60).should == middle_c
      end
    end

    describe '#to_midi' do
      it( "is 60 for middle C" ) { middle_c.to_midi.should == 60 }
      it( "is 0 for the C at octave -1" ) { lowest.to_midi.should == 0 }
      it( "is 127 for the G at octave 9" ) { highest.to_midi.should == 127 }
    end

    describe '#==' do
      it "compares the pitch_class and octave for equality" do
        middle_c.should == Pitch.new(c,4)
        middle_c.should_not == Pitch.new(c,3)
        middle_c.should_not == Pitch.new(g,4)
        middle_c.should_not == Pitch.new(g,3)
        highest.should == Pitch.new(g,9)                
      end
    end

  end
end