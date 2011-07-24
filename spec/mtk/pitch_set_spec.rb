require 'spec_helper'

describe MTK::PitchSet do

  describe ".new" do
    it "removes duplicates" do
      PitchSet.new([C4, E4, G4, E4, B3, C4]).pitches.should == [C4, E4, G4, B3]
    end
  end


end

describe MTK do

  describe '#PitchSet' do

    it "acts like new for a single Array argument" do
      PitchSet([C4,D4]).should == PitchSet.new([C4,D4])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      PitchSet(C4,D4).should == PitchSet.new([C4,D4])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      PitchSet(['C4','D4']).should == PitchSet.new([C4,D4])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      PitchSet(:C4,:D4).should == PitchSet.new([C4,D4])
    end

    it "handles a single Pitch" do
      PitchSet(C4).should == PitchSet.new([C4])
    end

    it "handles single elements that can be converted to a Pitch" do
      PitchSet('C4').should == PitchSet.new([C4])
    end

    it "returns the argument if it's already a PitchSet" do
      pitch_set = PitchSet.new([C4,D4,D4])
      PitchSet(pitch_set).should == PitchSet.new([C4,D4])
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchSet({:not => :compatible}) }.should raise_error
    end

  end

end
