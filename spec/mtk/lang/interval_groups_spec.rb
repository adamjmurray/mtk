require 'spec_helper'

describe MTK::Lang::IntervalGroups do  

  describe "MAJOR_TRIAD" do
    it "is the Intervals 0, 4, and 7" do
      IntervalGroups::MAJOR_TRIAD.should == [0,4,7].map{|value| MTK.Interval(value) }
    end
  end

  describe "MINOR_TRIAD" do
    it "is the Intervals 0, 3, and 7" do
      IntervalGroups::MINOR_TRIAD.should == [0,3,7].map{|value| MTK.Interval(value) }
    end
  end

  describe "DIMINISHED_TRIAD" do
    it "is the Intervals 0, 3, and 6" do
      IntervalGroups::DIMINISHED_TRIAD.should == [0,3,6].map{|value| MTK.Interval(value) }
    end
  end

  describe "AUGMENTED_TRIAD" do
    it "is the Intervals 0, 4, and 8" do
      IntervalGroups::AUGMENTED_TRIAD.should == [0,4,8].map{|value| MTK.Interval(value) }
    end
  end
  
  describe "scales and modes constants" do
    it "has over 40 interval group constants containing 5-12 unique intervals" do
      IntervalGroups::SCALES.length.should > 40
      for scale in IntervalGroups::SCALES
        scale.length.should be_between(5,12)
        scale.to_a.should == scale.to_a.uniq
      end
    end
  end

  describe ".find_scale" do
    it "looks up the scale constant by name" do
      IntervalGroups.find_scale('MAJOR_SCALE').should == IntervalGroups::MAJOR_SCALE
    end

    it "is case-insensitive" do
      IntervalGroups.find_scale('major_scale').should == IntervalGroups::MAJOR_SCALE
    end

    it "does not require the '_scale' suffix" do
      IntervalGroups.find_scale('minor').should == IntervalGroups::MINOR_SCALE
    end

    it "does not require the '_mode' suffix" do
      IntervalGroups.find_scale('dorian').should == IntervalGroups::DORIAN_MODE
    end

    it "handles spaces in the name" do
      IntervalGroups.find_scale('harmonic major').should == IntervalGroups::HARMONIC_MAJOR_SCALE
    end
  end

end


