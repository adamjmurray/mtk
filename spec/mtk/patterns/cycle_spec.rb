require 'spec_helper'

describe MTK::Patterns::Cycle do

  CYCLE = MTK::Patterns::Cycle

  let(:elements) { [1, 2, 3] }
  let(:cycle) { CYCLE.new elements }

  describe "#next" do
    it "iterates through the list of elements and emits them one at a time" do
      cycle.next.should == elements[0]
      cycle.next.should == elements[1]
      cycle.next.should == elements[2]
    end

    it "starts at the beginning of the list of elements after the end of the list is reached" do
      elements.length.times do
        cycle.next
      end
      cycle.next.should == elements.first
    end

    it "enumerates nested sequences" do
      cycle = CYCLE.new [1, MTK::Patterns.Sequence(2,3), 4]
      nexts = []
      6.times { nexts << cycle.next }
      nexts.should == [1,2,3,4,1,2]
    end
  end

  describe "#max_cycles" do
    it "is the :max_cycles option the pattern was constructed with" do
      CYCLE.new([], :max_cycles => 1).max_cycles.should == 1
    end

    it "is nil by default" do
      cycle.max_cycles.should be_nil
    end

    it "causes a StopIteration exception after the number of cycles has completed" do
      cycle = CYCLE.new(elements, :max_cycles => 2)
      2.times do
        elements.length.times { cycle.next } # one full cycle
      end
      lambda { cycle.next }.should raise_error
    end

    it "is maintained when applying Collection operations" do
      CYCLE.new(elements, :max_cycles => 2).reverse.max_cycles.should == 2
    end
  end

  describe "#max_elements" do
    it "causes a StopIteration exception after the number of elements have been emitted" do
      cycle = CYCLE.new(elements, :max_elements => 5)
      5.times { cycle.next }
      lambda { cycle.next }.should raise_error
    end
  end

  describe "#rewind" do
    it "restarts the cycle" do
      (elements.length - 1).times do
        cycle.next
      end
      cycle.rewind
      cycle.next.should == elements.first
    end
  end

end


describe MTK::Patterns do

  describe "#Cycle" do
    it "creates a Cycle" do
      MTK::Patterns.Cycle(1,2,3).should be_a MTK::Patterns::Cycle
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.Cycle(1,2,3).elements.should == [1,2,3]
    end
  end

  describe "#PitchCycle" do
    it "creates a Cycle" do
      MTK::Patterns.PitchCycle(1,2,3).should be_a MTK::Patterns::Cycle
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.PitchCycle(1,2,3).elements.should == [Pitch(1),Pitch(2),Pitch(3)]
    end
  end

  describe "#IntensityCycle" do
    it "creates a Cycle" do
      MTK::Patterns.IntensityCycle(1,2,3).should be_a MTK::Patterns::Cycle
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.IntensityCycle(1,2,3).elements.should == [Intensity(1),Intensity(2),Intensity(3)]
    end
  end

  describe "#DurationCycle" do
    it "creates a Cycle" do
      MTK::Patterns.DurationCycle(1,2,3).should be_a MTK::Patterns::Cycle
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.DurationCycle(1,2,3).elements.should == [Duration(1),Duration(2),Duration(3)]
    end
  end

end