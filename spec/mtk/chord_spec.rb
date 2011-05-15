require 'spec_helper'

describe Chord do

  let(:c_major) { Chord.new([C4,E4,G4]) }

  describe "#to_a" do
    it "does not include duplicates" do
      Chord.new([C4, E4, G4, C4]).to_a.should == [C4, E4, G4]
    end

    it "sorts the pitches" do
      Chord.new([G4, E4, C4]).to_a.should == [C4, E4, G4]
    end
  end

  describe '#==' do
    it "is true when all the pitches are equal" do
      Chord.new([C4, E4, G4]).should == Chord.new([Pitch.from_i(60), Pitch.from_i(64), Pitch.from_i(67)])
    end

    it "doesn't consider duplicates in the comparison" do
      Chord.new([C4, C4]).should == Chord.new([C4])
    end

    it "doesn't consider the order of pitches" do
      Chord.new([G4, E4, C4]).should == Chord.new([C4, E4, G4])
    end
  end

  describe '#inversion' do
    it "adds an octave to the chord's pitches starting from the lowest, for each whole number in a postive argument" do
      c_major.inversion(2).should == Chord.new([G4,C5,E5])
    end

    it "subtracts an octave to the chord's pitches starting fromt he highest, for each whole number in a negative argument" do
      c_major.inversion(-2).should == Chord.new([E3,G3,C4])
    end

    it "wraps around to the lowest pitch when the argument is bigger than the number of pitches in the chord (positive argument)" do
      c_major.inversion(4).should == Chord.new([E5,G5,C6])
    end

    it "wraps around to the highest pitch when the magnitude of the argument is bigger than the number of pitches in the chord (negative argument)" do
      c_major.inversion(-4).should == Chord.new([G2,C3,E3])
    end
  end

end
