require 'spec_helper'

describe MTK::Helper::EventBuilder do

  EVENT_BUILDER = MTK::Helper::EventBuilder

  let(:intensity) { EVENT_BUILDER::DEFAULT_INTENSITY }
  let(:duration)  { EVENT_BUILDER::DEFAULT_DURATION }

  def notes(*pitches)
    pitches.map{|pitch| Note(pitch, intensity, duration) }
  end


  describe "#next" do
    it "builds a single-note list from a single-pitch list argument" do
      event_builder = EVENT_BUILDER.new [Pattern.Cycle(C4)]
      event_builder.next.should == notes(C4)
    end

    it "builds a list of notes from any pitches in the argument" do
      event_builder = EVENT_BUILDER.new [Pattern.Cycle(C4), Pattern.Cycle(D4)]
      event_builder.next.should == notes(C4, D4)
    end

    it "builds a list of notes from pitch sets" do
      event_builder = EVENT_BUILDER.new [ Pattern.Cycle( PitchSet(C4,D4) ) ]
      event_builder.next.should == notes(C4, D4)
    end

    it "builds notes from pitch classes and a default_pitch, selecting the nearest pitch class to the previous pitch" do
      event_builder = EVENT_BUILDER.new [Pattern.Sequence(C,G,B,Eb,D,C)], :default_pitch => D3
      notes = []
      loop do
        notes << event_builder.next
      end
      notes.flatten.should == notes(C3,G2,B2,Eb3,D3,C3)
    end

    it "defaults to a starting point of C4 (middle C)" do
      event_builder = EVENT_BUILDER.new [Pattern.Sequence(C4)]
      event_builder.next.should == notes(C4)
    end

    it "builds notes from pitch class sets, selecting the neartest pitch classes to the previous/default pitch" do
      pitch_class_sequence = Pattern::Sequence.new([PitchClassSet(C,G),PitchClassSet(B,Eb),PitchClassSet(D,C)])
      event_builder = EVENT_BUILDER.new [pitch_class_sequence], :default_pitch => D3
      event_builder.next.should == notes(C3,G3)
      event_builder.next.should == notes(B3,Eb3)
      event_builder.next.should == notes(D3,C3)
    end

    it "builds notes from by adding Numeric intervals in :pitch type Patterns to the previous Pitch" do
      event_builder = EVENT_BUILDER.new [ Pattern.PitchSequence( C4, M3, m3, -P5) ]
      nexts = []
      loop { nexts << event_builder.next }
      nexts.should == [notes(C4), notes(E4), notes(G4), notes(C4)]
    end

    it "builds notes from by adding Numeric intervals in :pitch type Patterns to all pitches in the previous PitchSet" do
      event_builder = EVENT_BUILDER.new [ Pattern.PitchSequence( PitchSet(C4,Eb4), M3, m3, -P5) ]
      nexts = []
      loop { nexts << event_builder.next }
      nexts.should == [notes(C4,Eb4), notes(E4,G4), notes(G4,Bb4), notes(C4,Eb4)]
    end

    it "builds notes from intensities" do
      event_builder = EVENT_BUILDER.new [ Pattern.PitchCycle(C4), Pattern.IntensitySequence(mf, p, fff) ]
      nexts = []
      loop { nexts += event_builder.next }
      nexts.should == [Note(C4, mf, duration), Note(C4, p, duration), Note(C4, fff, duration)]
    end

    it "builds notes from durations" do
      event_builder = EVENT_BUILDER.new [ Pattern.PitchCycle(C4), Pattern.DurationSequence(1,2,3) ]
      nexts = []
      loop { nexts += event_builder.next }
      nexts.should == [Note(C4, intensity, 1), Note(C4, intensity, 2), Note(C4, intensity, 3)]
    end
  end

  describe "#rewind" do
    it "resets the state of the EventBuilder" do
      event_builder = EVENT_BUILDER.new [ Pattern.PitchSequence(C,P8) ]
      event_builder.next.should == [Note(C4,intensity,duration)]
      event_builder.next.should == [Note(C5,intensity,duration)]
      event_builder.rewind
      event_builder.next.should == [Note(C4,intensity,duration)]
    end
  end

end
