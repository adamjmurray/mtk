require 'spec_helper'

describe MTK::Chord do

  let(:pitch_set) { PitchSet.new [C4, E4, G4] }
  let(:intensity) { mf }
  let(:duration) { 2.5 }
  let(:chord) { Chord.new(pitch_set, intensity, duration) }

  describe "from_hash" do
    it "constructs a Chord using a hash" do
      Chord.from_hash({ :pitch_set => pitch_set, :intensity => intensity, :duration => duration }).should == chord
    end
  end

  describe "to_hash" do
    it "is a hash containing all the attributes of the Chord" do
      chord.to_hash.should == { :pitch_set => pitch_set, :intensity => intensity, :duration => duration }
    end
  end

  describe '#transpose' do
    it 'adds the given interval to the @pitch_set' do
      (chord.transpose 2.semitones).should == Chord.new(pitch_set+2, intensity, duration)
    end
    it 'does not affect the immutability of the Chord' do
      (chord.transpose 2.semitones).should_not == chord
    end
  end

  describe "#==" do
    it "is true when the pitch_sets, intensities, and durations are equal" do
      chord.should == Chord.new(pitch_set, intensity, duration)
    end

    it "is false when the pitch_sets are not equal" do
      chord.should_not == Chord.new(pitch_set + 1, intensity, duration)
    end

    it "is false when the intensities are not equal" do
      chord.should_not == Chord.new(pitch_set, intensity * 0.5, duration)
    end

    it "is false when the durations are not equal" do
      chord.should_not == Chord.new(pitch_set, intensity, duration * 2)
    end
  end

end
