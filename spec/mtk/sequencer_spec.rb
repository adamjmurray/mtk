require 'spec_helper'

describe MTK::Sequencer do

  describe "#next" do
    it "iterates through the pitch, intenisty, and duration list in parallel to emit Notes" do
      sequencer = Sequencer.new [C4, D4, E4], [p, f], [1,2,3,4]
      sequencer.next.should == Note.new(C4, p, 1)
      sequencer.next.should == Note.new(D4, f, 2)
      sequencer.next.should == Note.new(E4, p, 3)
      sequencer.next.should == Note.new(C4, f, 4)
      sequencer.next.should == Note.new(D4, p, 1)
      sequencer.next.should == Note.new(E4, f, 2)
    end

    it "defaults to intensity 'mf' when no intensities are given" do
      sequencer = Sequencer.new [C4, D4, E4], nil, [2]
      sequencer.next.should == Note.new(C4, mf, 2)
      sequencer.next.should == Note.new(D4, mf, 2)
      sequencer.next.should == Note.new(E4, mf, 2)
    end

    it "defaults to duration 1 when no durations are given" do
      sequencer = Sequencer.new [C4, D4, E4], [p, f]
      sequencer.next.should == Note.new(C4, p, 1)
      sequencer.next.should == Note.new(D4, f, 1)
      sequencer.next.should == Note.new(E4, p, 1)
    end
  end

  describe "#reset" do
    it "resets the sequence to the beginning" do
      sequencer = Sequencer.new [C4, D4, E4], [p, f], [1,2,3,4]
      sequencer.next.should == Note.new(C4, p, 1)
      sequencer.next.should == Note.new(D4, f, 2)
      sequencer.reset
      sequencer.next.should == Note.new(C4, p, 1)
      sequencer.next.should == Note.new(D4, f, 2)
    end
  end

end
