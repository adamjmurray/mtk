require 'spec_helper'

describe MTK::Sequencers::RhythmicSequencer do

  RHYTHMIC_SEQUENCER = Sequencers::RhythmicSequencer

  let(:pitches)     { Patterns.PitchSequence(C4, D4, E4, C4) }
  let(:intensities) { Patterns.IntensitySequence(0.3, 0.6, 0.9, 1.0) }
  let(:durations)   { Patterns.DurationSequence(1, 1, 2, 1) }
  let(:rhythm)      { Patterns.RhythmSequence(0.5, 1.5, 4) }
  let(:rhythmic_sequencer) { RHYTHMIC_SEQUENCER.new [pitches, intensities, durations], rhythm: rhythm }

  describe "#new" do
    it "defaults @max_steps to nil" do
      rhythmic_sequencer.max_steps.should be_nil
    end

    it "sets @max_steps from the options hash" do
      rhythmic_sequencer = RHYTHMIC_SEQUENCER.new [], rhythm: :mock_pattern, max_steps: 4
      rhythmic_sequencer.max_steps.should == 4
    end
  end

  describe "#to_timeline" do
    it "returns a Timeline" do
      rhythmic_sequencer.to_timeline.should be_a Timeline
    end

    it "contains notes assembled from the given patterns, with Timeline time deltas from the :rhythm type pattern" do
      rhythmic_sequencer.to_timeline.should == Timeline.from_hash({
        0 => Note(C4,0.3,1),
        0.5 => Note(D4,0.6,1),
        2.0 => Note(E4,0.9,2),
        6.0 => Note(C4,1.0,1)
      })
    end
  end

  describe "#max_steps" do
    it "controls the maximum number of times in the generated timeline" do
      rhythmic_sequencer.max_steps = 2
      rhythmic_sequencer.to_timeline.should == Timeline.from_hash({
        0 => Note(C4,0.3,1),
        0.5 => Note(D4,0.6,1)
      })
    end
  end

  describe "#rewind" do
    it "rewinds the rhythm pattern (in addition to normal #rewind behavior)" do
      rhythm.length.times{ rhythmic_sequencer.send :advance! }
      # now the next call would normally throw a StopIteration exception
      rhythmic_sequencer.rewind
      rhythm.length.times{ rhythmic_sequencer.send :advance! }
      # if we didn't get an exception, then #rewind did it's job
    end
  end

end