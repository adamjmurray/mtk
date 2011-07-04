require 'spec_helper'

describe MTK::Sequencer::StepSequencer do

  STEP_SEQUENCER = Sequencer::StepSequencer

  let(:pitches)     { Pattern.PitchSequence(C4, D4, E4) }
  let(:intensities) { Pattern.IntensitySequence(0.3, 0.7, 1.0) }
  let(:durations)   { Pattern.DurationSequence(1, 1, 2) }
  let(:step_sequencer) { STEP_SEQUENCER.new [pitches, intensities, durations] }

  describe "#new" do
    it "defaults @step_size to 1" do
      step_sequencer.step_size.should == 1
    end

    it "sets @step_size from the options hash" do
      step_sequencer = STEP_SEQUENCER.new nil, :step_size => 0.25
      step_sequencer.step_size.should == 0.25
    end

    it "defaults @max_steps to nil" do
      step_sequencer.max_steps.should be_nil
    end

    it "sets @max_steps from the options hash" do
      step_sequencer = STEP_SEQUENCER.new nil, :max_steps => 4
      step_sequencer.max_steps.should == 4
    end
  end

  describe "#to_timeline" do
    it "returns a Timeline" do
      timeline = step_sequencer.to_timeline
      timeline.should be_a Timeline
    end

    it "contains notes assembled from the given patterns" do
      timeline = step_sequencer.to_timeline
      timeline.should == Timeline.from_hash({
        0 => Note(C4,0.3,1),
        1 => Note(D4,0.7,1),
        2 => Note(E4,1.0,2)
      })
    end
  end

  describe "#step_size" do
    it "controls the delta between each time in the generated timeline" do
      step_sequencer.step_size = 2
      timeline = step_sequencer.to_timeline
      timeline.should == Timeline.from_hash({
        0 => Note(C4,0.3,1),
        2 => Note(D4,0.7,1),
        4 => Note(E4,1.0,2)
      })
    end
  end

  describe "#max_steps" do
    it "controls the maximum number of times in the generated timeline" do
      step_sequencer.max_steps = 2
      timeline = step_sequencer.to_timeline
      timeline.should == Timeline.from_hash({
        0 => Note(C4,0.3,1),
        1 => Note(D4,0.7,1)
      })
    end
  end

end