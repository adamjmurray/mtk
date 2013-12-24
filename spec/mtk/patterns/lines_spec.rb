require 'spec_helper'

describe MTK::Patterns::Lines do

  LINES = MTK::Patterns::Lines

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


describe MTK::Patterns do

  describe "#Lines" do
    it "creates a Lines" do
      MTK::Patterns.Lines(1,2,3).should be_a MTK::Patterns::Lines
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.Lines(1,2,3).elements.should == [1,2,3]
    end

    it "is includeable" do
      class PatternsIncluder
        include MTK::Patterns
      end
      pat = nil
      PatternsIncluder.new.instance_eval{ pat = Lines(1,2,3) }
      pat.should be_a MTK::Patterns::Lines
      pat.elements.should == [1, 2, 3]
    end
  end

  describe "#PitchLines" do
    it "creates a Lines" do
      MTK::Patterns.PitchLines(1,2,3).should be_a MTK::Patterns::Lines
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.PitchLines(1,2,3).elements.should == [Pitch(1),Pitch(2),Pitch(3)]
    end
  end

  describe "#IntensityLines" do
    it "creates a Lines" do
      MTK::Patterns.IntensityLines(1,2,3).should be_a MTK::Patterns::Lines
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.IntensityLines(1,2,3).elements.should == [Intensity(1),Intensity(2),Intensity(3)]
    end
  end

  describe "#DurationLines" do
    it "creates a Lines" do
      MTK::Patterns.DurationLines(1,2,3).should be_a MTK::Patterns::Lines
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.DurationLines(1,2,3).elements.should == [Duration(1),Duration(2),Duration(3)]
    end
  end

end