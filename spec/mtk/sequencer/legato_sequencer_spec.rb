require 'spec_helper'

describe MTK::Sequencer::LegatoSequencer do

  LEGATO_SEQUENCER = Sequencer::LegatoSequencer

  let(:pitches)     { Pattern.PitchSequence(C4, D4, E4, C4) }
  let(:intensities) { Pattern.IntensitySequence(0.3, 0.6, 0.9, 1.0) }
  let(:durations)   { Pattern.DurationSequence(1, 0.5, 1.5, 4) }
  let(:legato_sequencer) { LEGATO_SEQUENCER.new [pitches, intensities, durations] }


  describe "#to_timeline" do
    it "contains notes assembled from the given patterns, with Timeline time deltas from the max event duration at the previous step" do
      legato_sequencer.to_timeline.should == Timeline.from_hash({
        0 => Note(C4,0.3,1),
        1 => Note(D4,0.6,0.5),
        1.5 => Note(E4,0.9,1.5),
        3.0 => Note(C4,1.0,4)
      })
    end
  end

end