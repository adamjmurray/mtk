require 'spec_helper'
module TimelineSpec
  include Intervals
  include Dynamics

  describe MTK::Timeline do
      
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
      it "returns nil when no events exist at the timepoint" do
        timeline[3].should == nil
      end
    end
  
    describe "#has_time?" do
      it "returns true if the time has been assigned" do
        (timeline.has_time? 1).should be_true
      end
      it "returns false if the time doesn't exist" do
        (timeline.has_time? 3).should be_false
      end
    end
  
    describe "#times" do
      it "is the sorted list of times" do
        timeline.times.should == [0,1]
      end
    end
  
    describe "#to_hash" do
      it "returns the underlying Hash" do
        timeline.to_hash.should == {0 => [note1], 1 => [note1, note2]}
      end
    end
  
    describe "#==" do
      it "is true when the underlying Hashes are equal" do
        timeline.should == Timeline.new({ 0 => [note1], 1 => [note1, note2] })
      end
      it "is false when the underlying Hashes are not equal" do
        timeline.should_not == Timeline.new({ 0 => [note1], 1 => [note2, note1] })
      end
      it "allows for direct comparison to hashes" do
        timeline.should == { 0 => [note1], 1 => [note1, note2] }
      end
    end
  
    describe "#events" do
      pending
    end
  
    describe "#each" do
      pending
    end
  
    describe "#each_time" do
      pending
    end
  
  end
  
end