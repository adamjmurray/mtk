require 'spec_helper'

describe MTK::Sequencer::EventBuilder do

  EVENT_BUILDER = MTK::Sequencer::EventBuilder

  describe ".events_for" do
    it "builds a single-note list from a single-pitch list argument, defaulting to mf intensity and 1 duration" do
      EVENT_BUILDER.events_for([C4]).should == [Note(C4,mf,1)]
    end

    it "builds a list of notes from any pitches in the argument, defaulting to mf intensity and 1 duration" do
      EVENT_BUILDER.events_for([C4,D4]).should == [Note(C4,mf,1), Note(D4,mf,1)]
    end
  end

end
