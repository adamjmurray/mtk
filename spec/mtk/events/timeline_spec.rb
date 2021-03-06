require 'spec_helper'

describe MTK::Events::Timeline do

  let(:note1) { Note(C4, p, 1) }
  let(:note2) { Note(G4, f, 2) }
  let(:timeline_raw_data) { { 0.0 => note1, 1.0 => [note1, note2] } }
  let(:timeline_hash) { { 0.0 => [note1], 1.0 => [note1, note2] } }
  let(:timeline) { MTK::Events::Timeline.from_h(timeline_raw_data) }

  let(:unquantized_data) { { 0.0 => [note1], 0.7 => [note1], 1.1 => [note2], 1.24 => [note1], 1.25 => [note1] } }
  let(:unquantized_timeline) { MTK::Events::Timeline.from_h(unquantized_data) }
  let(:quantization_interval) { 0.5 }
  let(:quantized_data) { { 0.0 => [note1], 0.5 => [note1], 1.0 => [note2, note1], 1.5 => [note1] } }

  let(:shifted_data) { { 5.0 => [note1], 6.0 => [note1, note2] } }
  let(:reverse_shifted_data) { { -5.0 => [note1], -4.0 => [note1, note2] } }
  let(:shift_amount) { 5 }

  it "is Enumerable" do
    MTK::Events::Timeline.new.should be_a Enumerable
  end

  it "wraps lone values in arrays" do
    MTK::Events::Timeline.from_h(timeline_raw_data).should == MTK::Events::Timeline.from_h(timeline_hash)
  end

  describe "from_h" do
    it "creates an empty timeline when the hash is empty" do
      MTK::Events::Timeline.from_h({}).should be_empty
    end

    it "builds a Timeline from a map of times to single events" do
      t = MTK::Events::Timeline.from_h({ 0 => note1, 1 => note2 })
      t[0].should == [note1]
      t[1].should == [note2]
    end

    it "builds a Timeline from a map of times to event lists" do
      t = MTK::Events::Timeline.from_h({ 0 => [note1, note2], 1 => [note2] })
      t[0].should == [note1, note2]
      t[1].should == [note2]
    end
  end

  describe "from_a" do
    it "creates a timeline from an Enumerable" do
      MTK::Events::Timeline.from_a(timeline_hash.to_a).should == timeline
    end
  end

  describe "#to_h" do
    it "returns the underlying Hash" do
      timeline.to_h.should == timeline_hash
    end
  end

  describe "#clear" do
    it "clears the timeline" do
      timeline.clear.should be_empty
    end
  end

  describe "#merge" do
    it "merges all the time,event pairs in the given Enumerable into this Timeline" do
      timeline.merge({ 3 => note2 }).should == MTK::Events::Timeline.from_h( timeline_raw_data.merge({ 3 => note2 }) )
    end
  end

  describe "#empty?" do
    it "is true when the timeilne has no events" do
      MTK::Events::Timeline.new.empty?.should be_true
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

    it "coerces the argument for consistent lookup behavior" do
      timeline[0].should == [note1]
      timeline[0.0].should == [note1]
      timeline[Rational(0)].should == [note1]
      timeline[nil].should == [note1]
    end
  end


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

    it "coerces the argument to floating point for consistent lookup behavior" do
      timeline =  MTK::Events::Timeline.new
      timeline[nil] = note1
      timeline[1] = note1
      timeline[Rational(3,2)] = note1
      timeline.times.should == [0.0, 1.0, 1.5]
    end
  end


  describe "#add" do
    it "creates a new event list at a previously empty timepoint" do
      timeline.add(5, note1)
      timeline[5].should == [note1]
    end

    it "appends to existing event lists" do
      timeline.add(5, note1)
      timeline.add(5, note2)
      timeline[5].should == [note1, note2]
    end

    it "accepts a list of events as its second argument" do
      timeline.add 5, [note1, note2]
      timeline[5].should == [note1, note2]
    end

    it "coerces the argument to floating point for consistent lookup behavior" do
      timeline =  MTK::Events::Timeline.new
      timeline.add(nil, note1)
      timeline.add(1, note1)
      timeline.add(Rational(3,2), note1)
      timeline.times.should == [0.0, 1.0, 1.5]
    end
  end

  describe "#delete" do
    it "removes an event list at the given time" do
      timeline.delete(1)
      timeline.should == { 0.0 => [note1] }
    end

    it "coerces the argument to floating point for consistent lookup behavior" do
      timeline.delete(Rational(1))
      timeline.should == { 0.0 => [note1] }
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

  describe "length" do
    it "is the lastest time + the longest duration of events at that time" do
      len = timeline.length
      len.should be_a ::MTK::Core::Duration
      len.should == ::MTK.Duration(3)
    end
  end

  describe "empty?" do
    it "is true when there are no events in the timeline" do
       MTK::Events::Timeline.new.empty?.should be_true
    end

    it "is false where there are events in the timeline" do
      timeline.empty?.should be_false
    end
  end

  describe "#==" do
    it "is true when the underlying Hashes are equal" do
      timeline.should ==  MTK::Events::Timeline.from_h(timeline_hash)
    end
    it "is false when the underlying Hashes are not equal" do
      timeline.should_not ==  MTK::Events::Timeline.from_h( {0 => [note2], 1 => [note1, note2]} )
    end
    it "allows for direct comparison to hashes" do
      timeline.should == timeline_hash
    end
  end

  describe "#events" do
    it "is all events in a flattened array" do
      timeline.events.should == [note1, note1, note2]
    end
  end

  describe "#each" do
    it "yields each |time,event_list| pair" do
      yielded = []
      timeline.each{|time,events| yielded << [time,events] }
      yielded.should == [ [0,[note1]], [1,[note1,note2]] ]
    end
  end

  describe "#map" do
    it "returns a new  MTK::Events::Timeline where each [time,event] pair is replaced by the result of block" do
      mapped = timeline.map{|time,events| [time+1, events.map{|e| e.transpose(time+2) }] }
      mapped.should == { 1.0 => [note1.transpose(2)], 2.0 => [note1.transpose(3), note2.transpose(3)] }
    end

    it "handle events from different times being mapped to the same time" do
      timeline = MTK::Events::Timeline.from_h({ 0.0 => [note1], 1.0 => [note1], 2.0 => [note2] })
      mapped = timeline.map do |time,events|
        if events == [note1]
          [1.0, events]
        else
          [2.0, events]
        end
      end
      mapped.should == { 1.0 => [note1,note1], 2.0 => [note2] }
    end

    it "does not modify this  MTK::Events::Timeline" do
      timeline.map{|t,e| [0,nil] }
      timeline.should == timeline_hash
    end
  end

  describe "#map!" do
    it "maps the  MTK::Events::Timeline in place" do
      timeline.map! {|time,events| [time+1, events.map{|e| e.transpose(time+2) }] }
      timeline.should == { 1.0 => [note1.transpose(2)], 2.0 => [note1.transpose(3), note2.transpose(3)] }
    end
  end

  describe "#map_events" do
    it "maps the  MTK::Events::Timeline in place" do
      mapped = timeline.map_events {|event| event.transpose(1) }
      mapped.should == { 0.0 => [note1.transpose(1)], 1.0 => [note1.transpose(1), note2.transpose(1)] }
    end

    it "does not modify this  MTK::Events::Timeline" do
      timeline.map_events {|event| event.transpose(1) }
      timeline.should == timeline_hash
    end
  end

  describe "#map_events!" do
    it "maps the  MTK::Events::Timeline in place" do
      timeline.map_events! {|event| event.transpose(1.0) }
      timeline.should == { 0.0 => [note1.transpose(1)], 1.0 => [note1.transpose(1), note2.transpose(1)] }
    end
  end

  describe "#compact!" do
    it "removes empty event lists" do
      timeline[3] = []
      timeline[4] = []
      timeline.compact!
      timeline.should == timeline_hash
    end
  end

  describe "#quantize" do
    it "maps all times to the nearest multiple of the given interval" do
      unquantized_timeline.quantize(quantization_interval).should == quantized_data
    end
    it "returns a new  MTK::Events::Timeline and does not modify the original" do
      unquantized_timeline.quantize(quantization_interval)
      unquantized_timeline.should == unquantized_data
    end
  end

  describe "#quantize!" do
    it "maps all times to the nearest multiple of the given interval" do
      unquantized_timeline.quantize!(quantization_interval).should == quantized_data
    end

    it "modifies the  MTK::Events::Timeline in place" do
      unquantized_timeline.quantize!(quantization_interval)
      unquantized_timeline.should == quantized_data
    end
  end

  describe "#shift" do
    it "shifts all times by the given amount" do
      timeline.shift(shift_amount).should == shifted_data
    end

    it "goes back in time for negative arguments" do
      timeline.shift(-shift_amount).should == reverse_shifted_data
    end

    it "returns an instance of the same type" do
      timeline.shift(shift_amount).should be_a timeline.class
    end

    it "returns a new  MTK::Events::Timeline and does not modify the original" do
      timeline.shift(shift_amount).should_not equal timeline
    end
  end

  describe "#shift!" do
    it "shifts all times by the given amount" do
      timeline.shift!(shift_amount).should == shifted_data
    end

    it "goes back in time for negative arguments" do
      timeline.shift!(-shift_amount).should == reverse_shifted_data
    end

    it "modifies the timeline in place" do
      timeline.shift!(shift_amount).should equal timeline
    end
  end

  describe "#shift_to" do
    it "shifts so the start is at the given time" do
       MTK::Events::Timeline.from_h(shifted_data).shift_to(0).should == timeline
       MTK::Events::Timeline.from_h(reverse_shifted_data).shift_to(0).should == timeline
    end

    it "returns an instance of the same type" do
      timeline.shift_to(shift_amount).should be_a timeline.class
    end

    it "returns a new  MTK::Events::Timeline and does not modify the original" do
      timeline.shift_to(shift_amount).should_not equal timeline
    end
  end

  describe "#shift_to!" do
    it "shifts so the start is at the given time" do
       MTK::Events::Timeline.from_h(shifted_data).shift_to!(0).should == timeline
       MTK::Events::Timeline.from_h(reverse_shifted_data).shift_to!(0).should == timeline
    end

    it "modifies the timeline in place" do
      timeline.shift_to!(shift_amount).should equal timeline
    end
  end

  describe "#flatten" do
    it "flattens nested timelines so that all nested subtimes are converted to absolute times in a single timeline" do
      timeline[10] =  MTK::Events::Timeline.from_h({ 0 => note2, 1 => note1 })
      timeline.flatten.should == timeline_hash.merge({ 10.0 => [note2], 11.0 => [note1] })
    end
    
    it "handles nested timelines which have nested timelines inside of them" do
      nested =  MTK::Events::Timeline.from_h({ 0 => note1 })
      timeline[10] =  MTK::Events::Timeline.from_h({ 100 => nested })
      timeline.flatten.should == timeline_hash.merge({ 110.0 => [note1] })
    end

    it "handles multiple nested timeslines at the same time point" do
      timeline[10] = [ MTK::Events::Timeline.from_h({ 0 => note2, 1 => note1 }),  MTK::Events::Timeline.from_h({ 2 => note1, 3 => note2 })]
      timeline.flatten.should == timeline_hash.merge({ 10.0 => [note2], 11.0 => [note1], 12.0 => [note1], 13.0 => [note2] })
    end
    
    it "returns a new  MTK::Events::Timeline" do
      timeline.flatten.should_not equal(timeline)
    end
  end

  describe "#clone" do
    it "creates an equal  MTK::Events::Timeline" do
      timeline.clone.should == timeline
    end

    it "returns a new instance" do
      timeline.clone.should_not equal(timeline)
    end
  end

  describe ".quantize_time" do
    it "takes a time and an interval, and returns the nearest multiple of the interval to the time" do
       MTK::Events::Timeline.quantize_time(23,10).should == 20
       MTK::Events::Timeline.quantize_time(27,10).should == 30
       MTK::Events::Timeline.quantize_time(30,10).should == 30
    end

    it "rounds up when exactly between 2 intervals" do
       MTK::Events::Timeline.quantize_time(25,10).should == 30
    end

    it "handles fractional intervals" do
       MTK::Events::Timeline.quantize_time(13,2.5).should == 12.5
    end
  end

  describe "#to_s" do
    it "has one line per time" do
      timeline.to_s.split("\n").size.should == timeline.times.size
    end

    it "has a time => event_list mapping on each line" do
      for line in timeline.to_s.split("\n")
        line.should =~ /=>/
      end
    end

    it "pretty prints the output by aligning all '=>' arrows" do
      # alignment is only a factor when the times have different numbers of digits:
      timeline =  MTK::Events::Timeline.new
      timeline.add 0, note1
      timeline.add 10, note1
      timeline.add 1000, note1
      lines = timeline.to_s.split("\n")
      last = lines.pop
      arrow_position = last =~ /=>/
      for line in lines
        (line =~ /=>/).should == arrow_position
      end
    end

    it "returns empty string for empty timelines" do
      MTK::Events::Timeline.new.to_s.should == ''
    end
  end
end

