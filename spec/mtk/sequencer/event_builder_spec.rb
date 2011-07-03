require 'spec_helper'

describe MTK::Sequencer::EventBuilder do

  EVENT_BUILDER = MTK::Sequencer::EventBuilder

  let(:event_builder) { EVENT_BUILDER.new }

  def notes(*pitches)
    pitches.map{|pitch| Note(pitch, EVENT_BUILDER::DEFAULT_INTENSITY, EVENT_BUILDER::DEFAULT_DURATION) }
  end

  describe ".next_events" do
    it "builds a single-note list from a single-pitch list argument" do
      pitch_cycle = Pattern::Cycle.new([C4])
      event_builder.next_events([pitch_cycle]).should == notes(C4)
    end

    it "builds a list of notes from any pitches in the argument" do
      pitch_cycle1 = Pattern::Cycle.new([C4])
      pitch_cycle2 = Pattern::Cycle.new([D4])
      event_builder.next_events([pitch_cycle1, pitch_cycle2]).should == notes(C4, D4)
    end

    it "builds notes from pitch classes and a default_pitch, selecting the nearest pitch class to the previous pitch" do
      event_builder = EVENT_BUILDER.new :default_pitch => D3
      pitch_class_sequence = Pattern::Sequence.new([C,G,B,Eb,D,C])
      notes = []
      loop do
        notes << event_builder.next_events([pitch_class_sequence])
      end
      notes.flatten.should == notes(C3,G2,B2,Eb3,D3,C3)
    end

    it "defaults to a starting point of C4 (middle C)" do
      pitch_class_sequence = Pattern::Sequence.new([C])
      event_builder.next_events([pitch_class_sequence]).should == notes(C4)
    end

  end

end
