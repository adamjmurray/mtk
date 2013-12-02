require 'spec_helper'

describe MTK::Lang::IntervalGroups do

  INTERVAL_GROUPS = MTK::Lang::IntervalGroups

  describe "MAJOR_TRIAD" do
    it "is the Intervals 0, 4, and 7" do
      INTERVAL_GROUPS::MAJOR_TRIAD.should == [0,4,7].map{|value| MTK.Interval(value) }
    end
  end

  describe "MINOR_TRIAD" do
    it "is the Intervals 0, 3, and 7" do
      INTERVAL_GROUPS::MINOR_TRIAD.should == [0,3,7].map{|value| MTK.Interval(value) }
    end
  end

  describe "DIMINISHED_TRIAD" do
    it "is the Intervals 0, 3, and 6" do
      INTERVAL_GROUPS::DIMINISHED_TRIAD.should == [0,3,6].map{|value| MTK.Interval(value) }
    end
  end

  describe "AUGMENTED_TRIAD" do
    it "is the Intervals 0, 4, and 8" do
      INTERVAL_GROUPS::AUGMENTED_TRIAD.should == [0,4,8].map{|value| MTK.Interval(value) }
    end
  end

end


