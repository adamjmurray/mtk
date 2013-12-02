require 'spec_helper'

describe MTK::Groups::IntervalGroup do

  INTERVAL_GROUP = MTK::Groups::IntervalGroup
  MAJOR_TRIAD = MTK::Lang::IntervalGroups::MAJOR_TRIAD
  MINOR_TRIAD = MTK::Lang::IntervalGroups::MINOR_TRIAD

  C_MAJOR_SCALE = MTK.PitchClassGroup(C,D,E,F,G,A,B)

  describe "#intervals" do
    it "is the intervals the object was constructed with" do
      INTERVAL_GROUP.new([m2,M3,P4]).intervals.should == [m2,M3,P4]
    end
  end

  describe "#to_pitch_classes" do
    context "constructed with a base index" do
      it "converts to an Array of PitchClasses when given a root PitchClass" do
        MAJOR_TRIAD.to_pitch_classes(D).should == [D,Gb,A]
      end
    end
  end

  describe "#to_pitches" do
    context "constructed with a base index" do
      it "converts to an Array of Pitches when given a root Pitch" do
        MAJOR_TRIAD.to_pitches(F3).should == [F3,A3,C4]
      end
    end
  end

end


describe MTK do

  describe '#IntervalGroup' do

    it "acts like new for a single Array argument" do
      IntervalGroup([P1,M3]).should == MTK::Groups::IntervalGroup.new([P1,M3])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      IntervalGroup(P1,M3).should == MTK::Groups::IntervalGroup.new([P1,M3])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      IntervalGroup(['P1','M3']).should == MTK::Groups::IntervalGroup.new([P1,M3])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      IntervalGroup(:P1,:M3).should == MTK::Groups::IntervalGroup.new([P1,M3])
    end

    it "handles a single Pitch" do
      IntervalGroup(M3).should == MTK::Groups::IntervalGroup.new([M3])
    end

    it "handles single elements that can be converted to a Pitch" do
      IntervalGroup('M3').should == MTK::Groups::IntervalGroup.new([M3])
    end

    it "handles a IntervalGroup" do
      interval_group = MTK::Groups::IntervalGroup.new([P1,M3])
      IntervalGroup(interval_group).should == [P1,M3]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ IntervalGroup({:not => :compatible}) }.should raise_error
    end

  end

end