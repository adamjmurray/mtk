require 'spec_helper'

describe MTK::Groups::RelativeChord do

  let(:scale_index) { 3 }
  let(:interval_group) { MTK::Groups::IntervalGroup.new([P1,M3,P5])}
  let(:relative_chord) { RELATIVE_CHORD.new(scale_index, interval_group) }

  describe "#scale_index" do
    it "is the first argument the object was constructed with" do
      relative_chord.scale_index.should == scale_index
    end
  end

  describe "#interval_group" do
    it "is the second argument the object was constructed with" do
      relative_chord.interval_group.should == interval_group
    end
  end

  describe ".from_s" do
    {
      'I'    => ['MAJOR_TRIAD', 0, MAJOR_TRIAD],
      'i'    => ['MINOR_TRIAD', 0, MINOR_TRIAD],
      'II'   => ['MAJOR_TRIAD', 1, MAJOR_TRIAD],
      'ii'   => ['MINOR_TRIAD', 1, MINOR_TRIAD],
      'III'  => ['MAJOR_TRIAD', 2, MAJOR_TRIAD],
      'iii'  => ['MINOR_TRIAD', 2, MINOR_TRIAD],
      'IV'   => ['MAJOR_TRIAD', 3, MAJOR_TRIAD],
      'iv'   => ['MINOR_TRIAD', 3, MINOR_TRIAD],
      'V'    => ['MAJOR_TRIAD', 4, MAJOR_TRIAD],
      'v'    => ['MINOR_TRIAD', 4, MINOR_TRIAD],
      'VI'   => ['MAJOR_TRIAD', 5, MAJOR_TRIAD],
      'vi'   => ['MINOR_TRIAD', 5, MINOR_TRIAD],
      'VII'  => ['MAJOR_TRIAD', 6, MAJOR_TRIAD],
      'vii'  => ['MINOR_TRIAD', 6, MINOR_TRIAD],
      'VIII' => ['MAJOR_TRIAD', 7, MAJOR_TRIAD],
      'viii' => ['MINOR_TRIAD', 7, MINOR_TRIAD],
      'IX'   => ['MAJOR_TRIAD', 8, MAJOR_TRIAD],
      'ix'   => ['MINOR_TRIAD', 8, MINOR_TRIAD]
    }.each do |input, expectations|
      name,scale_index,interval_group = *expectations

      it "interprets '#{input}' as a #{name} at scale_index #{scale_index}" do
        relative_chord = RELATIVE_CHORD.from_s(input)
        relative_chord.interval_group.should == interval_group
        relative_chord.scale_index.should == scale_index
      end
    end
  end


  describe "#to_pitch_classes" do
    it "converts to an Array of PitchClasses in the given scale" do
      pitch_classes = relative_chord.to_pitch_classes( [C3,D3,E3,F3,G3,A3,B3] )
      pitch_classes.should be_a Array
      pitch_classes.should == [F,A,C]
    end
  end

  describe "#to_pitch_class_group" do
    it "acts like #to_pitch_classes but returns a PitchClassGroup" do
      pitch_class_group = relative_chord.to_pitch_class_group( [C3,D3,E3,F3,G3,A3,B3] )
      pitch_class_group.should be_a MTK::Groups::PitchClassGroup
      pitch_class_group.should == [F,A,C]
    end
  end


  describe "#to_pitches" do
    it "converts to pitches when given a scale as an Array of Pitches" do
      pitches = relative_chord.to_pitches( [C3,D3,E3,F3,G3,A3,B3] )
      pitches.should be_a Array
      pitches.should == [F3,A3,C4]
    end

    it "converts to pitches when given a scale as a PitchGroup" do
      relative_chord.to_pitches( MTK.PitchGroup(C3,D3,E3,F3,G3,A3,B3) ).should == [F3,A3,C4]
    end

    it "converts to pitches with root pitch nearest C4 when given a scale as an Array of PitchClasses" do
      relative_chord.to_pitches( [C,D,E,F,G,A,B] ).should == [F4,A4,C5]
    end

    it "converts to pitches with root pitch nearest C4 when given a scale as a PitchGroup" do
      relative_chord.to_pitches( MTK.PitchClassGroup(C,D,E,F,G,A,B) ).should == [F4,A4,C5]
    end

    it "converts to a chord with root pitch nearest the given Pitch when given a scale as an Array of PitchClasses" do
      relative_chord.to_pitches( [C,D,E,F,G,A,B], C6 ).should == [F6,A6,C7]
    end

    it "converts to a chord with root pitch nearest the given Pitch when given a scale as a PitchGroup" do
      relative_chord.to_pitches( MTK.PitchClassGroup(C,D,E,F,G,A,B), D6 ).should == [F6,A6,C7]
    end

    it "converts to a chord with root pitch in the given octave when given a scale as an Array of PitchClasses" do
      relative_chord.to_pitches( [C,D,E,F,G,A,B], 5 ).should == [F5,A5,C6]
    end

    it "converts to a chord with root pitch in the given octave when given a scale as a PitchGroup" do
      relative_chord.to_pitches( MTK.PitchClassGroup(C,D,E,F,G,A,B), 5 ).should == [F5,A5,C6]
    end
  end

  describe "#to_pitch_group" do
    it "acts like #to_pitches but returns a PitchGroup" do
      pitch_group = relative_chord.to_pitch_group( [C,D,E,F,G,A,B], C6 )
      pitch_group.should be_a MTK::Groups::PitchGroup
      pitch_group.should == [F6,A6,C7]

      pitch_group = relative_chord.to_pitch_group( [C,D,E,F,G,A,B], 5 )
      pitch_group.should be_a MTK::Groups::PitchGroup
      pitch_group.should == [F5,A5,C6]
    end
  end

  describe "#to_chord" do
    it "acts like #to_pitches but returns a Chord" do
      chord = relative_chord.to_chord( [C,D,E,F,G,A,B], C6 )
      chord.should be_a MTK::Groups::Chord
      chord.should == [F6,A6,C7]
      chord
      chord = relative_chord.to_chord( [C,D,E,F,G,A,B], 5 )
      chord.should be_a MTK::Groups::Chord
      chord.should == [F5,A5,C6]
    end
  end

  describe "#==" do
    it "is true if the scale_index and interval_group are equal" do
      RELATIVE_CHORD.new(scale_index, interval_group).should == RELATIVE_CHORD.new(scale_index, interval_group)
    end
  end

end