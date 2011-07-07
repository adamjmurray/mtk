require 'spec_helper'

describe MTK::Helper::EventBuilder do

  EVENT_BUILDER = MTK::Helper::EventBuilder

  def notes(*pitches)
    pitches.map{|pitch| Note(pitch, EVENT_BUILDER::DEFAULT_INTENSITY, EVENT_BUILDER::DEFAULT_DURATION) }
  end

  describe "#next_events" do
    it "builds a single-note list from a single-pitch list argument" do
      event_builder = EVENT_BUILDER.new [Pattern.Cycle(C4)]
      event_builder.next_events.should == notes(C4)
    end

    it "builds a list of notes from any pitches in the argument" do
      event_builder = EVENT_BUILDER.new [Pattern.Cycle(C4), Pattern.Cycle(D4)]
      event_builder.next_events.should == notes(C4, D4)
    end

    it "builds a list of notes from pitch sets" do
      event_builder = EVENT_BUILDER.new [ Pattern.Cycle( PitchSet(C4,D4) ) ]
      event_builder.next_events.should == notes(C4, D4)
    end

    it "builds notes from pitch classes and a default_pitch, selecting the nearest pitch class to the previous pitch" do
      event_builder = EVENT_BUILDER.new [Pattern.Sequence(C,G,B,Eb,D,C)], :default_pitch => D3
      notes = []
      loop do
        notes << event_builder.next_events
      end
      notes.flatten.should == notes(C3,G2,B2,Eb3,D3,C3)
    end

    it "defaults to a starting point of C4 (middle C)" do
      event_builder = EVENT_BUILDER.new [Pattern.Sequence(C4)]
      event_builder.next_events.should == notes(C4)
    end

    it "builds notes from pitch class sets, selecting the neartest pitch classes to the previous/default pitch" do
      pitch_class_sequence = Pattern::Sequence.new([PitchClassSet(C,G),PitchClassSet(B,Eb),PitchClassSet(D,C)])
      event_builder = EVENT_BUILDER.new [pitch_class_sequence], :default_pitch => D3
      event_builder.next_events.should == notes(C3,G3)
      event_builder.next_events.should == notes(B3,Eb3)
      event_builder.next_events.should == notes(D3,C3)
    end

  end

end
