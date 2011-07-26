require 'spec_helper'

describe MTK::Chord do

  let(:c_major) { Chord.new([C4,E4,G4]) }

  describe ".new" do
    it "removes duplicates" do
      Chord.new([C4, E4, G4, C4]).pitches.should == [C4, E4, G4]
    end

    it "sorts the pitches" do
      Chord.new([F4, G4, E4, D4, C4]).pitches.should == [C4, D4, E4, F4, G4]
    end
  end

  describe '#inversion' do
    it "adds an octave to the chord's pitches starting from the lowest, for each whole number in a postive argument" do
      c_major.inversion(2).should == Melody.new([G4,C5,E5])
    end

    it "subtracts an octave to the chord's pitches starting fromt he highest, for each whole number in a negative argument" do
      c_major.inversion(-2).should == Melody.new([E3,G3,C4])
    end

    it "wraps around to the lowest pitch when the argument is bigger than the number of pitches in the chord (positive argument)" do
      c_major.inversion(4).should == Melody.new([E5,G5,C6])
    end

    it "wraps around to the highest pitch when the magnitude of the argument is bigger than the number of pitches in the chord (negative argument)" do
      c_major.inversion(-4).should == Melody.new([G2,C3,E3])
    end
  end

  describe "#nearest" do
    it "returns the nearest Melody where the first Pitch has the given PitchClass" do
      c_major.nearest(F).should == c_major.transpose(5)
      c_major.nearest(G).should == c_major.transpose(-5)
    end
  end

end

describe MTK do

  describe '#Chord' do

    it "acts like new for a single Array argument" do
      Chord([C4,D4]).should == Chord.new([C4,D4])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      Chord(C4,D4).should == Chord.new([C4,D4])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      Chord(['C4','D4']).should == Chord.new([C4,D4])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      Chord(:C4,:D4).should == Chord.new([C4,D4])
    end

    it "handles a single Pitch" do
      Chord(C4).should == Chord.new([C4])
    end

    it "handles single elements that can be converted to a Pitch" do
      Chord('C4').should == Chord.new([C4])
    end

    it "returns the argument if it's already a Chord" do
      pitch_set = Chord.new([C4,D4,D4])
      Chord(pitch_set).should == Chord.new([C4,D4])
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Chord({:not => :compatible}) }.should raise_error
    end

  end

end
