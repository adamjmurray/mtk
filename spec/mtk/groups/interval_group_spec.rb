require 'spec_helper'

describe MTK::Groups::IntervalGroup do

  INTERVAL_GROUP = MTK::Groups::IntervalGroup
  MAJOR_TRIAD = INTERVAL_GROUP::MAJOR_TRIAD
  MINOR_TRIAD = INTERVAL_GROUP::MINOR_TRIAD

  C_MAJOR_SCALE = MTK.PitchClassGroup(C,D,E,F,G,A,B)


  describe "MAJOR_TRIAD" do
    it "is the Intervals 0, 4, and 7" do
      INTERVAL_GROUP::MAJOR_TRIAD.should == [0,4,7].map{|value| MTK.Interval(value) }
    end
  end

  describe "MINOR_TRIAD" do
    it "is the Intervals 0, 3, and 7" do
      INTERVAL_GROUP::MINOR_TRIAD.should == [0,3,7].map{|value| MTK.Interval(value) }
    end
  end


  describe "#intervals" do
    it "is the intervals the object was constructed with" do
      INTERVAL_GROUP.new([m2,M3,P4]).intervals.should == [m2,M3,P4]
    end
  end

  describe "#base" do
    it "is the second argument the object was constructed with" do
      INTERVAL_GROUP.new([m2], 0).base.should == 0
    end

    it "is optional" do
      INTERVAL_GROUP.new([m2]).base.should be_nil
    end
  end

  describe ".from_s" do
    {
      'I'    => ['MAJOR_TRIAD', MAJOR_TRIAD, 0],
      'i'    => ['MINOR_TRIAD', MINOR_TRIAD, 0],
      'II'   => ['MAJOR_TRIAD', MAJOR_TRIAD, 1],
      'ii'   => ['MINOR_TRIAD', MINOR_TRIAD, 1],
      'III'  => ['MAJOR_TRIAD', MAJOR_TRIAD, 2],
      'iii'  => ['MINOR_TRIAD', MINOR_TRIAD, 2],
      'IV'   => ['MAJOR_TRIAD', MAJOR_TRIAD, 3],
      'iv'   => ['MINOR_TRIAD', MINOR_TRIAD, 3],
      'V'    => ['MAJOR_TRIAD', MAJOR_TRIAD, 4],
      'v'    => ['MINOR_TRIAD', MINOR_TRIAD, 4],
      'VI'   => ['MAJOR_TRIAD', MAJOR_TRIAD, 5],
      'vi'   => ['MINOR_TRIAD', MINOR_TRIAD, 5],
      'VII'  => ['MAJOR_TRIAD', MAJOR_TRIAD, 6],
      'vii'  => ['MINOR_TRIAD', MINOR_TRIAD, 6],
      'VIII' => ['MAJOR_TRIAD', MAJOR_TRIAD, 7],
      'viii' => ['MINOR_TRIAD', MINOR_TRIAD, 7],
      'IX'   => ['MAJOR_TRIAD', MAJOR_TRIAD, 8],
      'ix'   => ['MINOR_TRIAD', MINOR_TRIAD, 8]
    }.each do |input, expectations|
      name,intervals,base = *expectations
      it "interprets '#{input}' as a #{name} with base #{base}" do
        interval_group = INTERVAL_GROUP.from_s(input)
        interval_group.intervals.should == intervals
        interval_group.base.should == base
      end
    end
  end

  describe "#to_pitch_class_group" do
    context "constructed with a base index" do
      it "converts to a PitchClassGroup when given a scale named parameter" do
        major_dominant = INTERVAL_GROUP.from_s('V')
        pitch_class_group = major_dominant.to_pitch_class_group(scale: C_MAJOR_SCALE)
        pitch_class_group.should be_a MTK::Groups::PitchClassGroup
        pitch_class_group.pitch_classes.should == [G,B,D]
      end

      # TODO: test all the other edge cases
    end
  end

  describe "#to_pitch_group" do
    context "constructed with a base index" do
      it "converts to a PitchGroup when given a scale and nearest_pitch named parameters" do
        major_dominant = INTERVAL_GROUP.from_s('V')
        pitch_class_group = major_dominant.to_pitch_group(scale: C_MAJOR_SCALE, nearest_pitch: C4)
        pitch_class_group.should be_a MTK::Groups::PitchGroup
        pitch_class_group.pitches.should == [G3,B3,D4]
      end
    end

      # TODO: test all the other edge cases
  end

end