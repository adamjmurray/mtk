require 'spec_helper'

describe MTK::Sequencer do

  def note(pitch, intensity=mf, duration=1)
    Note.new pitch,intensity,duration
  end

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

    it "defaults to Pitch 'C4' when no pitches are given" do
      sequencer = Sequencer.new [], [p,f], [1,2,3]
      sequencer.next.should == Note.new(C4, p, 1)
      sequencer.next.should == Note.new(C4, f, 2)
      sequencer.next.should == Note.new(C4, p, 3)
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

    it "users the previous pitch/intensity/duration when it encounters a nil value" do
      sequencer = Sequencer.new [C4, D4, E4, F4, nil], [mp, mf, f, nil], [1, 2, nil]
      sequencer.next.should == Note.new(C4, mp, 1)
      sequencer.next.should == Note.new(D4, mf, 2)
      sequencer.next.should == Note.new(E4, f, 2)
      sequencer.next.should == Note.new(F4, f, 1)
      sequencer.next.should == Note.new(F4, mp, 2)
      sequencer.next.should == Note.new(C4, mf, 2)
    end

    it "adds Numeric intervals in the pitch list to the previous pitch" do
      sequencer = Sequencer.new [C4, 1, 2, 3]
      sequencer.next.should == note(C4)
      sequencer.next.should == note(C4+1)
      sequencer.next.should == note(C4+1+2)
      sequencer.next.should == note(C4+1+2+3)
      sequencer.next.should == note(C4)
    end

    it "goes to the nearest Pitch for any PitchClasses in the pitch list" do
      sequence = Sequencer.new [C4, F, C, G, C]
      sequence.next.should == note(C4)
      sequence.next.should == note(F4)
      sequence.next.should == note(C4)
      sequence.next.should == note(G3)
      sequence.next.should == note(C4)
    end

    it "does not endlessly ascend or descend when alternating between two pitch classes a tritone apart" do
      sequence = Sequencer.new [C4, Gb, C, Gb, C]
      sequence.next.should == note(C4)
      sequence.next.should == note(Gb4)
      sequence.next.should == note(C4)
      sequence.next.should == note(Gb4)
      sequence.next.should == note(C4)
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
