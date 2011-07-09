require 'spec_helper'

describe MTK::Sequencer::AbstractSequencer do

  ABSTRACT_SEQUENCER = Sequencer::AbstractSequencer

  class MockEventBuilder < Helper::EventBuilder
    attr_accessor :mock_attribute
  end

  let(:patterns)  { [Pattern.PitchCycle(C4,D4)] }
  let(:sequencer) { ABSTRACT_SEQUENCER.new patterns }
  let(:intensity) { Helper::EventBuilder::DEFAULT_INTENSITY }
  let(:duration)  { Helper::EventBuilder::DEFAULT_DURATION }

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
      sequencer = RHYTHMIC_SEQUENCER.new patterns, :max_time => 4
      sequencer.max_time.should == 4
    end

    it "defaults @event_builder to MTK::Helper::EventBuilder" do
      sequencer.event_builder.should be_a MTK::Helper::EventBuilder
    end

    it "sets @event_buidler from the options hash" do
      sequencer = RHYTHMIC_SEQUENCER.new patterns, :event_builder => MockEventBuilder
      sequencer.event_builder.should be_a MockEventBuilder
    end
  end

  describe "#event_builder" do
    it "provides access to the internal EventBuilder" do
      sequencer = RHYTHMIC_SEQUENCER.new patterns, :event_builder => MockEventBuilder
      sequencer.event_builder.mock_attribute = :value
      sequencer.event_builder.mock_attribute.should == :value
    end
  end

  describe "#to_timeline" do
    it "combines pitch, intensity, and duration patterns into notes" do
      pitches = Pattern.PitchSequence(C4, D4, E4)
      intensities = Pattern.IntensitySequence(0.3, 0.7, 1.0)
      durations = Pattern.DurationSequence(1, 2, 3)
      sequencer = ABSTRACT_SEQUENCER.new [pitches, intensities, durations]
      # default implementation just increments the time by 1 for each event (more interesting behavior is provided by subclasses)
      sequencer.to_timeline.should == {
        0 => [Note(C4,0.3,1)],
        1 => [Note(D4,0.7,2)],
        2 => [Note(E4,1.0,3)]
      }
    end

    it "combines patterns of different types and lengths" do
      pitches = Pattern.PitchSequence(C4, D4, E4, F4, G4, A4, B4, C5)
      intensities = Pattern.IntensityCycle(0.5, 1.0)
      durations = Pattern.DurationPalindrome(1, 2, 3)
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
      pitches = Pattern.PitchSequence(C4, D4, E4)
      intensities = Pattern.IntensityCycle(1)
      durations = Pattern.DurationCycle(1, 2)
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
      relative_pitch_pattern = Pattern.PitchSequence(C,P8)
      sequencer = ABSTRACT_SEQUENCER.new [relative_pitch_pattern]
      sequencer.next.should == [Note(C4,intensity,duration)]
      sequencer.next.should == [Note(C5,intensity,duration)]
      sequencer.rewind
      sequencer.next.should == [Note(C4,intensity,duration)] # if the internal EventBuilder is not properly reset, the Note would be C5
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