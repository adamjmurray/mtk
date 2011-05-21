require 'spec_helper'

describe MTK::Chord do

  let(:pitch_set) { PitchSet.new [C4, E4, G4] }
  let(:intensity) { mf }
  let(:duration) { 2.5 }
  let(:chord) { Chord.new(pitch_set, intensity, duration) }

  it "can be constructed with a PitchSet" do
    pitch_set = PitchSet.new([C4])
    Chord.new( pitch_set, intensity, duration ).pitch_set.should == pitch_set
  end

  it "can be constructed with an Array of Pitches" do
    Chord.new( [C4], intensity, duration ).pitch_set.should == PitchSet.new([C4])
  end

  describe "#pitch_set" do
    it "is the pitch_set used to create the Chord" do
      chord.pitch_set.should == pitch_set
    end

    it "is a read-only attribute" do
      lambda{ chord.pitch_set = PitchSet.new }.should raise_error
    end
  end

  describe "#pitches" do
    it "is the list of pitches in the pitch_set" do
      chord.pitches.should == chord.pitch_set.pitches
    end
  end

  describe "from_hash" do
    it "constructs a Chord using a hash" do
      Chord.from_hash({ :pitch_set => pitch_set, :intensity => intensity, :duration => duration }).should == chord
    end
  end

  describe "#to_hash" do
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
