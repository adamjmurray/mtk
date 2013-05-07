require 'spec_helper'

describe MTK::Sequencers::Sequencer do

  ABSTRACT_SEQUENCER = Sequencers::Sequencer

  class MockEventBuilder < Patterns::Chain
    attr_accessor :mock_attribute
  end

  let(:patterns)  { [Patterns.PitchCycle(C4,D4)] }
  let(:sequencer) { ABSTRACT_SEQUENCER.new patterns }
  let(:pitch) { Patterns::Chain::DEFAULT_PITCH }
  let(:intensity) { Patterns::Chain::DEFAULT_INTENSITY }
  let(:duration)  { Patterns::Chain::DEFAULT_DURATION }

  describe "#new" do
    it "defaults @max_steps to nil" do
      sequencer.max_steps.should be_nil
    end

    it "sets @max_steps from the options hash" do
      sequencer = RHYTHMIC_SEQUENCER.new patterns, :max_steps => 4
      sequencer.max_steps.should == 4
    end

    it "defaults @max_time to nil" do
      sequencer.max_time.should be_nil
    end

    it "sets @max_time from the options hash" do
      sequencer = ABSTRACT_SEQUENCER.new patterns, :max_time => 4
      sequencer.max_time.should == 4
    end

    it "defaults @event_builder to MTK::Patterns::EventChain" do
      sequencer.event_builder.should be_a MTK::Patterns::Chain
    end

    it "sets @event_buidler from the options hash" do
      sequencer = ABSTRACT_SEQUENCER.new patterns, :event_builder => MockEventBuilder
      sequencer.event_builder.should be_a MockEventBuilder
    end
    
    it "allows default pitch to be specified" do
      sequencer = ABSTRACT_SEQUENCER.new [Patterns.IntervalCycle(0)], :default_pitch => Gb4
      sequencer.next.should == [Note(Gb4, intensity, duration)]
    end
    it "allows default intensity to be specified" do
      sequencer = ABSTRACT_SEQUENCER.new [Patterns.IntervalCycle(0)], :default_intensity => ppp
      sequencer.next.should == [Note(pitch, ppp, duration)]
    end
    it "allows default duration to be specified" do
      sequencer = ABSTRACT_SEQUENCER.new [Patterns.IntervalCycle(0)], :default_duration => 5.25
      sequencer.next.should == [Note(pitch, intensity, 5.25)]
    end  
  end

  describe "#event_builder" do
    it "provides access to the internal EventBuilder" do
      sequencer = ABSTRACT_SEQUENCER.new patterns, :event_builder => MockEventBuilder
      sequencer.event_builder.mock_attribute = :value
      sequencer.event_builder.mock_attribute.should == :value
    end
  end

  describe "#to_timeline" do
    it "combines pitch, intensity, and duration patterns into notes" do
      pitches = Patterns.PitchSequence(C4, D4, E4)
      intensities = Patterns.IntensitySequence(0.3, 0.7, 1.0)
      durations = Patterns.DurationSequence(1, 2, 3)
      sequencer = ABSTRACT_SEQUENCER.new [pitches, intensities, durations]
      # default implementation just increments the time by 1 for each event (more interesting behavior is provided by subclasses)
      sequencer.to_timeline.should == {
        0 => [Note(C4,0.3,1)],
        1 => [Note(D4,0.7,2)],
        2 => [Note(E4,1.0,3)]
      }
    end

    it "combines patterns of different types and lengths" do
      pitches = Patterns.PitchSequence(C4, D4, E4, F4, G4, A4, B4, C5)
      intensities = Patterns.IntensityCycle(0.5, 1.0)
      durations = Patterns.DurationPalindrome(1, 2, 3)
      sequencer = ABSTRACT_SEQUENCER.new [pitches, intensities, durations]
      # default implementation just increments the time by 1 for each event (more interesting behavior is provided by subclasses)
      sequencer.to_timeline.should == {
        0 => [Note(C4,0.5,1)],
        1 => [Note(D4,1.0,2)],
        2 => [Note(E4,0.5,3)],
        3 => [Note(F4,1.0,2)],
        4 => [Note(G4,0.5,1)],
        5 => [Note(A4,1.0,2)],
        6 => [Note(B4,0.5,3)],
        7 => [Note(C5,1.0,2)]
      }
    end

    it "produces consistent results by reseting the patterns each time" do
      pitches = Patterns.PitchSequence(C4, D4, E4)
      intensities = Patterns.IntensityCycle(1)
      durations = Patterns.DurationCycle(1, 2)
      sequencer = ABSTRACT_SEQUENCER.new [pitches, intensities, durations]
      sequencer.to_timeline.should == sequencer.to_timeline
    end
  end

  describe "#time" do
    it "is the current timeline time that the sequencer is generating events for" do
      # AbstractSequencer just advances by 1 each step
      sequencer.next # time doesn't advance until the second #next call
      sequencer.time.should == 0
      sequencer.next
      sequencer.time.should == 1
      sequencer.next
      sequencer.time.should == 2
    end
  end

  describe "#step" do
    it "is the index for how many of times #next has been called (i.e. count starting from 0)" do
      sequencer.step.should == -1 # -1 indicates #next has not yet been called
      sequencer.next
      sequencer.step.should == 0
      sequencer.next
      sequencer.step.should == 1
      sequencer.next
      sequencer.step.should == 2
    end
  end

  describe "#next" do
    it "returns a list of notes formed from the patterns in the sequencer"  do
      sequencer.next.should == [Note(C4,intensity,duration)]
      sequencer.next.should == [Note(D4,intensity,duration)]
      sequencer.next.should == [Note(C4,intensity,duration)]
    end

    it "returns a filtered list of notes if the sequencer was constructed with a options[:filter] lambda" do
      sequencer = ABSTRACT_SEQUENCER.new patterns, :filter => lambda{|events| events.map{|event| event.transpose(P8) } }
      sequencer.next.should == [Note(C5,intensity,duration)]
      sequencer.next.should == [Note(D5,intensity,duration)]
    end

    context "pitch patterns" do
      it "adds Numeric elements (intervals) to the previous pitch" do
        sequencer = ABSTRACT_SEQUENCER.new [Patterns.Cycle(C4, m2, M2, m3)]
        sequencer.next.should == [Note(C4,intensity,duration)]
        sequencer.next.should == [Note(C4+1,intensity,duration)]
        sequencer.next.should == [Note(C4+1+2,intensity,duration)]
        sequencer.next.should == [Note(C4+1+2+3,intensity,duration)]
      end

      it "returns a note with the given pitch when encountering a Pitch after another type" do
        sequencer = ABSTRACT_SEQUENCER.new [Patterns.Cycle(C4, m2, C4)]
        sequencer.next
        sequencer.next
        sequencer.next.should == [Note(C4,intensity,duration)]
      end

      it "goes to the nearest Pitch for any PitchClasses in the pitch list" do
        sequencer = ABSTRACT_SEQUENCER.new [Patterns.Cycle(C4, F, C, G, C)]
        sequencer.next.should == [Note(C4,intensity,duration)]
        sequencer.next.should == [Note(F4,intensity,duration)]
        sequencer.next.should == [Note(C4,intensity,duration)]
        sequencer.next.should == [Note(G3,intensity,duration)]
        sequencer.next.should == [Note(C4,intensity,duration)]
      end

      it "does not endlessly ascend or descend when alternating between two pitch classes a tritone apart" do
        sequencer = ABSTRACT_SEQUENCER.new [Patterns.Cycle(C4, Gb, C, Gb, C)]
        sequencer.next.should == [Note(C4,intensity,duration)]
        sequencer.next.should == [Note(Gb4,intensity,duration)]
        sequencer.next.should == [Note(C4,intensity,duration)]
        sequencer.next.should == [Note(Gb4,intensity,duration)]
        sequencer.next.should == [Note(C4,intensity,duration)]
      end
    end

  end

  describe "#rewind" do
    it "resets the sequencer and its patterns" do
      sequencer.next
      sequencer.rewind
      sequencer.step.should == -1
      sequencer.time.should == 0
      sequencer.next.should == [Note(C4,intensity,duration)]
    end

    it "resets pitches properly for patterns that rely on previous pitches" do
      relative_pitch_pattern = Patterns.Sequence(C,P8)
      sequencer = ABSTRACT_SEQUENCER.new [relative_pitch_pattern]
      sequencer.next.should == [Note(C4,intensity,duration)]
      sequencer.next.should == [Note(C5,intensity,duration)]
      sequencer.rewind
      sequencer.next.should == [Note(C4,intensity,duration)] # if the internal EventChain is not properly reset, the Note would be C5
    end
  end

  describe "#max_steps" do
    it "controls the maximum number of entries in the generated timeline" do
      sequencer.max_steps = 2
      sequencer.to_timeline.times.length.should == 2
    end
  end

  describe "#max_time" do
    it "controls the maximum time in the generated timeline" do
      sequencer.max_time = 4
      sequencer.to_timeline.times.last.should == 4
    end
  end

end