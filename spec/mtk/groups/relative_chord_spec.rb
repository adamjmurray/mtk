require 'spec_helper'

describe MTK::Groups::RelativeChord do

  RELATIVE_CHORD = MTK::Groups::RelativeChord
  MAJOR_TRIAD = MTK::Lang::IntervalGroups::MAJOR_TRIAD
  MINOR_TRIAD = MTK::Lang::IntervalGroups::MINOR_TRIAD

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


  describe "#to_chord" do
    it "converts to a chord in the given scale as an Array of Pitches" do
      chord = relative_chord.to_chord( [C3,D3,E3,F3,G3,A3,B3] )
      chord.should be_a Groups::Chord
      chord.should == [F3,A3,C4]
    end

    it "converts to a chord in the given scale as a PitchGroup" do
      chord = relative_chord.to_chord( MTK.PitchGroup(C3,D3,E3,F3,G3,A3,B3) )
      chord.should be_a Groups::Chord
      chord.should == [F3,A3,C4]
    end

    it "converts to a chord with root pitch in the default octave 4 in the given scale as an Array of PitchClasses" do
      chord = relative_chord.to_chord( [C,D,E,F,G,A,B] )
      chord.should be_a Groups::Chord
      chord.should == [F4,A4,C5]
    end

    it "converts to a chord in the default octave 4 in the given scale as a PitchGroup" do
      chord = relative_chord.to_chord( MTK.PitchClassGroup(C,D,E,F,G,A,B) )
      chord.should be_a Groups::Chord
      chord.should == [F4,A4,C5]
    end

    it "converts to a chord with root pitch in the given scale as an Array of PitchClasses and the given octave" do
      chord = relative_chord.to_chord( [C,D,E,F,G,A,B], 5 )
      chord.should be_a Groups::Chord
      chord.should == [F5,A5,C6]
    end

    it "converts to a chord in the given scale as a PitchGroup and the given octave" do
      chord = relative_chord.to_chord( MTK.PitchClassGroup(C,D,E,F,G,A,B), 5 )
      chord.should be_a Groups::Chord
      chord.should == [F5,A5,C6]
    end
  end


  describe "#==" do
    it "is true if the scale_index and interval_group are equal" do
      RELATIVE_CHORD.new(scale_index, interval_group).should == RELATIVE_CHORD.new(scale_index, interval_group)
    end
  end

end