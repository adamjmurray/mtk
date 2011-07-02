require 'spec_helper'

describe MTK::Sequencer::EventBuilder do

  EVENT_BUILDER = MTK::Sequencer::EventBuilder

  let(:event_builder) { EVENT_BUILDER.new }

  describe ".next_events" do
    it "builds a single-note list from a single-pitch list argument, defaulting to mf intensity and 1 duration" do
      pitch_cycle = Pattern::Cycle.new([C4])
      event_builder.next_events([pitch_cycle]).should == [Note(C4,mf,1)]
    end

    it "builds a list of notes from any pitches in the argument, defaulting to mf intensity and 1 duration" do
      pitch_cycle1 = Pattern::Cycle.new([C4])
      pitch_cycle2 = Pattern::Cycle.new([D4])
      event_builder.next_events([pitch_cycle1, pitch_cycle2]).should == [Note(C4,mf,1), Note(D4,mf,1)]
    end

  end

end
