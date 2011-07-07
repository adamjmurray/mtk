require 'spec_helper'

describe MTK::Sequencer::AbstractSequencer do

  ABSTRACT_SEQUENCER = Sequencer::AbstractSequencer

  let(:patterns)   { [Pattern.PitchCycle(C4)] }
  let(:sequencer) { ABSTRACT_SEQUENCER.new patterns }

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

  describe "#next" do
    pending
  end

  describe "#rewind" do
    pending
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