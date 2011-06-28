require 'spec_helper'

describe MTK::Sequencer::StepSequencer do

  SEQUENCE = MTK::Pattern::Sequence
  STEP_SEQUENCER = MTK::Sequencer::StepSequencer

  let(:pitches)     { MTK::Pattern.PitchSequence(C4, D4, E4) }
  let(:intensities) { MTK::Pattern.IntensitySequence(0.3, 0.7, 1.0) }
  let(:durations)   { MTK::Pattern.DurationSequence(1, 1, 2) }
  let(:step_sequencer) { STEP_SEQUENCER.new [pitches, intensities, durations] }

  describe "#to_timeline" do
    it "returns a Timeline" do
      timeline = step_sequencer.to_timeline
      timeline.should be_a Timeline
    end

    it "contains notes assembled from the given patterns" do
      timeline = step_sequencer.to_timeline
      timeline.should == MTK::Timeline.from_hash({
        0 => MTK.Note(C4,0.3,1),
        1 => MTK.Note(D4,0.7,1),
        2 => MTK.Note(E4,1.0,2)
      })
    end
  end

end