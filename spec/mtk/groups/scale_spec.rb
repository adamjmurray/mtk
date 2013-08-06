require 'spec_helper'

describe MTK::Groups::Scale do

  SCALE = MTK::Groups::Scale

  let(:scale_steps) { [C,D,E,F,G,A,B] }
  let(:scale) { SCALE.new(scale_steps) }


  describe '#steps' do
    it 'is the #elements' do
      scale.steps.should == scale.elements
    end
  end

  describe '#tonic' do
    it 'is the same as #first' do
      scale.tonic.should == scale.first
    end
  end

  describe '#step' do
    it 'returns the pitch class at the given step number' do
      scale.step(2).should == D
    end

    it 'wraps around the end of the end of the scale' do
      scale.step(8).should == C
    end

    it 'returns nil when the Scale is empty' do
      SCALE.new([]).step(1).should be_nil
    end

    it 'returns nil when the step number is 0' do
      scale.step(0).should be_nil
    end

    it 'returns nil when the step number is negative' do
      scale.step(-1).should be_nil
    end
  end

  describe '#pitch_for_step' do
    it 'returns a pitch with the pitch class at the given step number, closest to the given nearest pitch' do
      scale.pitch_for_step(2,E6).should == D6
    end

    it 'defaults to a nearest pitch of C4 is no nearest pitch (second argument) is given' do
      scale.pitch_for_step(1).should == C4
    end

    it 'adds an octave for each time the step number "wraps around" the scale' do
      scale.pitch_for_step(15).should == C6
    end

    it 'returns nil when the Scale is empty' do
      SCALE.new([]).pitch_for_step(1).should be_nil
    end

    it 'returns nil when the step number is 0' do
      scale.pitch_for_step(0).should be_nil
    end

    it 'returns nil when the step number is negative' do
      scale.pitch_for_step(-1).should be_nil
    end
  end

end


describe MTK do

  describe '#Scale' do

    it "constructs a Scale" do
      Scale(C,D).should be_a SCALE
    end

    it "acts like new for a single Array argument" do
      Scale([C,D]).should == SCALE.new([C,D])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      Scale(C,D).should == SCALE.new([C,D])
    end

    it "handles an Array with elements that can be converted to PitchClasses" do
      Scale(['C','D']).should == SCALE.new([C,D])
    end

    it "handles multiple arguments that can be converted to a PitchClass" do
      Scale(:C,:D).should == SCALE.new([C,D])
    end

    it "handles a single PitchClass" do
      Scale(C).should == SCALE.new([C])
    end

    it "handles single elements that can be converted to a PitchClass" do
      Scale('C').should == SCALE.new([C])
    end

    it "handles a a PitchClassGroup" do
      pitch_set = SCALE.new([C,D])
      Scale(pitch_set).should == Scale([C,D])
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchClassGroup({:not => :compatible}) }.should raise_error
    end

  end

end