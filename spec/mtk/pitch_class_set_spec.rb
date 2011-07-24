require 'spec_helper'

describe MTK::PitchClassSet do

  describe ".new" do
    it "removes duplicates" do
      PitchClassSet.new([C, E, G, E, B, C]).pitch_classes.should == [C, E, G, B]
    end
  end

end

describe MTK do

  describe '#PitchClassSet' do

    it "constructs a PitchClassSet" do
      PitchClassSet(C,D).should be_a PitchClassSet
    end

    it "acts like new for a single Array argument" do
      PitchClassSet([C,D,D]).should == PitchClassSet.new([C,D])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      PitchClassSet(C,D,D).should == PitchClassSet.new([C,D])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      PitchClassSet(['C','D','D']).should == PitchClassSet.new([C,D])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      PitchClassSet(:C,:D,:D).should == PitchClassSet.new([C,D])
    end

    it "handles a single Pitch" do
      PitchClassSet(C).should == PitchClassSet.new([C])
    end

    it "handles single elements that can be converted to a Pitch" do
      PitchClassSet('C').should == PitchClassSet.new([C])
    end

    it "handles a a PitchClassSet" do
      pitch_set = PitchClassSet.new([C,D,D])
      PitchClassSet(pitch_set).should == PitchClassSet([C,D])
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchClassSet({:not => :compatible}) }.should raise_error
    end

  end

end