require 'spec_helper'

describe MTK::Pattern::Lines do

  LINES = MTK::Pattern::Lines

  let(:elements) { [0, [10,5], [5,10]] }
  let(:lines) { LINES.new elements }

  describe "#next" do
    it "interpolates between values, treating each element as [value, steps_to_value] pairs" do
      nexts = []
      loop do
        nexts << lines.next
      end
      nexts.should == [0, 2,4,6,8,10, 9.5,9,8.5,8,7.5,7,6.5,6,5.5,5]
    end
  end

  describe "#rewind" do
    it "starts the pattern from the beginning" do
      10.times { lines.next }
      lines.rewind
      nexts = []
      loop do
        nexts << lines.next
      end
      nexts.should == [0, 2,4,6,8,10, 9.5,9,8.5,8,7.5,7,6.5,6,5.5,5]
    end
  end

end


describe MTK::Pattern do

  describe "#Lines" do
    it "creates a Lines" do
      MTK::Pattern.Lines(1,2,3).should be_a MTK::Pattern::Lines
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.Lines(1,2,3).elements.should == [1,2,3]
    end

    it "does not set a type" do
      MTK::Pattern.Lines(1,2,3).type.should be_nil
    end
  end

  describe "#PitchLines" do
    it "creates a Lines" do
      MTK::Pattern.PitchLines(1,2,3).should be_a MTK::Pattern::Lines
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.PitchLines(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.PitchLines([]).type.should == :pitch
    end
  end

  describe "#IntensityLines" do
    it "creates a Lines" do
      MTK::Pattern.IntensityLines(1,2,3).should be_a MTK::Pattern::Lines
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.IntensityLines(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.IntensityLines([]).type.should == :intensity
    end
  end

  describe "#DurationLines" do
    it "creates a Lines" do
      MTK::Pattern.DurationLines(1,2,3).should be_a MTK::Pattern::Lines
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.DurationLines(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.DurationLines([]).type.should == :duration
    end
  end

end