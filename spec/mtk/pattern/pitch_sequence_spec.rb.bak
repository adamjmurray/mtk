require 'spec_helper'

describe MTK::Pattern::PitchSequence do

  let(:pitches) { [C4,D4,E4] }
  let(:pitch_sequence) { Pattern::PitchSequence.new(pitches) }

  describe "#elements" do
    it "is the array the sequence was constructed with" do
      pitch_sequence.elements.should == pitches
    end
  end

  describe "#pitches" do
    it "behaves like #elements" do
      pitch_sequence.pitches.should == pitch_sequence.elements
    end
  end

  describe ".from_pitch_classes" do
    it "creates a pitch sequence from a list of pitch classes and starting point, selecting the nearest pitch to each pitch class" do
      Pattern::PitchSequence.from_pitch_classes([C,G,B,Eb,D,C], D3).should == [C3,G2,B2,Eb3,D3,C3]
    end

    it "defaults to a starting point of C4 (middle C)" do
      Pattern::PitchSequence.from_pitch_classes([C]).should == [C4]
    end

    it "doesn't travel within an octave above or below the starting point by default" do
      Pattern::PitchSequence.from_pitch_classes([C,F,Bb,D,A,E,B]).should == [C4,F4,Bb4,D4,A3,E3,B3]
    end

    it "allows max distance above or below the starting point to be set via the third argument" do
      Pattern::PitchSequence.from_pitch_classes([C,F,Bb,D,A,E,B], C4, 6).should == [C4,F4,Bb3,D4,A3,E4,B3]
    end
  end

  describe "#repeat" do
    it "repeats the sequence the number of times given by the argument" do
      pitch_sequence.repeat(3).should == [C4,D4,E4, C4,D4,E4, C4,D4,E4]
    end

    it "repeats the sequence twice if no argument is given" do
      pitch_sequence.repeat.should == [C4,D4,E4, C4,D4,E4]
    end

    it "handles fractional repetitions" do
      pitch_sequence.repeat(2.67).should == [C4,D4,E4, C4,D4,E4, C4,D4]
    end
  end

end

describe MTK::Pattern do

  describe "#PitchSequence" do
    it "takes multiple arguments instead of a single Array argument" do
      Pattern.PitchSequence(C4,D4,E4).elements.should == [C4,D4,E4]
    end

    it "converts the arguments to Pitches when possible" do
      Pattern.PitchSequence(:C4,:D4,:E4).elements.should == [C4,D4,E4]
    end
  end

end
