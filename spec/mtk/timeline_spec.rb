require 'spec_helper'

describe MTK::Timeline do
  include Intervals
  include Dynamics

  let(:note1) { Note.new(C4, P, 1) }
  let(:note2) { Note.new(G4, F, 2) }
  let(:timeline) { Timeline.new({0 => note1, 1 => [note1, note2]}) }


  describe "#[]=" do
    it "set a single event at the given timepoint" do
      timeline[5] = note1
      timeline[5].should == [note1]
    end
    it "set an array of events at the given timepoint" do
      timeline[5] = [note1, note2]
      timeline[5].should == [note1, note2]
    end
    it "replaces existing events at the timepoint" do
      timeline[5] = note1
      timeline[5] = note2
      timeline[5].should == [note2]
    end
  end

  describe "#[]" do
    it "returns an array of the event(s) at the timepoint" do
      timeline[0].should == [note1]
      timeline[1].should == [note1, note2]
    end
    it "returns an empty array when no events exist at the timepoint" do
      timeline[3].should == []
    end
    it "can be chained with << to easily build up timelines" do
      timeline[3] << note1
      timeline[3] << note2
      timeline[3].should == [note1, note2]
    end
  end

  describe "#has_timepoint?" do
    it "returns true if the timepoint exists with events" do
      (timeline.has_timepoint? 1).should be_true
    end
    it "returns false if the timepoint doesn't exist" do
      (timeline.has_timepoint? 3).should be_false
    end
    it "returns false if the timepoint doesn't have events" do
      timeline[3] = []
      (timeline.has_timepoint? 3).should be_false
    end
  end

  describe "#timepoints" do
    it "is the sorted list of timepoints" do
      timeline.timepoints.should == [0,1]
    end
    it "omits timepoints with no events" do
      timeline[3] = []
      timeline.timepoints.should == [0,1]
    end
  end

  describe "#to_hash" do
    it "returns the underlying Hash" do
      timeline.to_hash.should == {0 => [note1], 1 => [note1, note2]}
    end
  end

end
