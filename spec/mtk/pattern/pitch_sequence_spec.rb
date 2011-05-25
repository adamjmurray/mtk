require 'spec_helper'

describe MTK::Pattern::PitchSequence do

  describe "#next" do
    it "enumerates Pitches" do
      sequence = Pattern::PitchSequence.new [C4, D4, E4]
      sequence.next.should == C4
      sequence.next.should == D4
      sequence.next.should == E4
    end

    it "adds Numeric elements (intervals) to the previous pitch" do
      sequence = Pattern::PitchSequence.new [C4, 1, 2, 3]
      sequence.next.should == C4
      sequence.next.should == C4+1
      sequence.next.should == C4+1+2
      sequence.next.should == C4+1+2+3
    end

    it "returns a Pitch when encountering a Pitch after another type" do
      sequence = Pattern::PitchSequence.new [C4, 1, C4]
      sequence.next
      sequence.next
      sequence.next.should == C4
    end

    it "goes to the nearest Pitch for any PitchClasses in the pitch list" do
      sequence = Pattern::PitchSequence.new [C4, F, C, G, C]
      sequence.next.should == C4
      sequence.next.should == F4
      sequence.next.should == C4
      sequence.next.should == G3
      sequence.next.should == C4
    end

    it "does not endlessly ascend or descend when alternating between two pitch classes a tritone apart" do
      sequencer = Pattern::PitchSequence.new [C4, Gb, C, Gb, C]
      sequencer.next.should == C4
      sequencer.next.should == Gb4
      sequencer.next.should == C4
      sequencer.next.should == Gb4
      sequencer.next.should == C4
    end

  end
end
