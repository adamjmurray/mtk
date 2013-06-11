require 'spec_helper'

describe MTK::Sequencers::LegatoSequencer do

  LEGATO_SEQUENCER = Sequencers::LegatoSequencer

  let(:pitches)     { Patterns.PitchSequence(C4, D4, E4, C4) }
  let(:durations)   { Patterns.DurationSequence(1, 0.5, 1.5, 4) }
  let(:intensities) { Patterns.IntensitySequence(0.3, 0.6, 0.9, 1.0) }
  let(:legato_sequencer) { LEGATO_SEQUENCER.new [pitches, durations, intensities] }


  describe "#to_timeline" do
    it "contains notes assembled from the given patterns, with Timeline time deltas from the max event duration at the previous step" do
      legato_sequencer.to_timeline.should ==  MTK::Events::Timeline.from_hash({
        0   => Note(C4,1,0.3),
        1.0 => Note(D4,0.5,0.6),
        1.5 => Note(E4,1.5,0.9),
        3.0 => Note(C4,4,1.0)
      })
    end

    it "treats negative durations as rests" do
      legato_sequencer = LEGATO_SEQUENCER.new( [pitches, Patterns.DurationSequence(-1,-0.5,-1.5,4), intensities] )
      legato_sequencer.to_timeline.should ==  MTK::Events::Timeline.from_hash({
        3.0 => Note(C4,4,1.0)
      })
    end
  end

end


describe MTK::Sequencers do

  describe "#LegatoSequencer" do
    it "creates a LegatoSequencer" do
      MTK::Sequencers.LegatoSequencer(1,2,3, rhythm:1).should be_a MTK::Sequencers::LegatoSequencer
    end

    it "sets #patterns from the varargs" do
      MTK::Sequencers.LegatoSequencer(1,2,3, rhythm:1).patterns.should == [1,2,3]
    end
  end
end