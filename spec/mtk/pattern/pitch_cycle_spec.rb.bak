require 'spec_helper'

describe MTK::Pattern::PitchCycle do

  describe "#next" do
    it "enumerates Pitches" do
      cycle = Pattern::PitchCycle.new [C4, D4, E4]
      cycle.next.should == C4
      cycle.next.should == D4
      cycle.next.should == E4
    end

    it "adds Numeric elements (intervals) to the previous pitch" do
      cycle = Pattern::PitchCycle.new [C4, 1, 2, 3]
      cycle.next.should == C4
      cycle.next.should == C4+1
      cycle.next.should == C4+1+2
      cycle.next.should == C4+1+2+3
    end

    it "returns a Pitch when encountering a Pitch after another type" do
      cycle = Pattern::PitchCycle.new [C4, 1, C4]
      cycle.next
      cycle.next
      cycle.next.should == C4
    end

    it "goes to the nearest Pitch for any PitchClasses in the pitch list" do
      cycle = Pattern::PitchCycle.new [C4, F, C, G, C]
      cycle.next.should == C4
      cycle.next.should == F4
      cycle.next.should == C4
      cycle.next.should == G3
      cycle.next.should == C4
    end

    it "does not endlessly ascend or descend when alternating between two pitch classes a tritone apart" do
      cycler = Pattern::PitchCycle.new [C4, Gb, C, Gb, C]
      cycler.next.should == C4
      cycler.next.should == Gb4
      cycler.next.should == C4
      cycler.next.should == Gb4
      cycler.next.should == C4
    end

  end
end
