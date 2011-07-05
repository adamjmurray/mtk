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

  # we describe "#to_timeline" in the subclass specs, since this depends on overriden behavior for #advance

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