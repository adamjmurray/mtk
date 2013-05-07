require 'spec_helper'

describe MTK::Patterns::Sequence do

  SEQUENCE = MTK::Patterns::Sequence

  let(:elements) { [1,2,3] }
  let(:sequence) { SEQUENCE.new(elements) }

  it "is a MTK::Collection" do
    sequence.should be_a MTK::Helpers::Collection
    # and now we won't test any other collection features here... see collection_spec
  end

  describe ".from_a" do
    it "acts like .new" do
      SEQUENCE.from_a(elements).should == sequence
    end
  end

  describe "#elements" do
    it "is the array the sequence was constructed with" do
      sequence.elements.should == elements
    end
  end

  describe "#next" do
    it "enumerates the elements" do
      nexts = []
      elements.length.times do
        nexts << sequence.next
      end
      nexts.should == elements
    end

    it "raises StopIteration when the end of the Sequence is reached" do
      elements.length.times{ sequence.next }
      lambda{ sequence.next }.should raise_error(StopIteration)
    end

    it "should automatically break out of Kernel#loop" do
      nexts = []
      loop do # loop rescues StopIteration and exits the loop
        nexts << sequence.next
      end
      nexts.should == elements
    end

    it "enumerates the elements in sub-sequences" do
      sub_sequence = SEQUENCE.new [2,3]
      sequence = SEQUENCE.new [1,sub_sequence,4]
      nexts = []
      loop { nexts << sequence.next }
      nexts.should == [1,2,3,4]
    end

    it "skips over empty sub-sequences" do
      sub_sequence = SEQUENCE.new []
      sequence = SEQUENCE.new [1,sub_sequence,4]
      nexts = []
      loop { nexts << sequence.next }
      nexts.should == [1,4]
    end

  end

  describe "#rewind" do
    it "restarts at the beginning of the sequence" do
      loop { sequence.next }
      sequence.rewind
      sequence.next.should == elements.first
    end

    it "returns self, so it can be chained to #next" do
      first = sequence.next
      sequence.rewind.next.should == first
    end

    it "causes sub-sequences to start from the beginning when encountered again after #rewind" do
      sub_sequence = SEQUENCE.new [2,3]
      sequence = SEQUENCE.new [1,sub_sequence,4]
      loop { sequence.next }
      sequence.rewind
      nexts = []
      loop { nexts << sequence.next }
      nexts.should == [1,2,3,4]
    end
  end

end


describe MTK::Patterns do

  describe "#Sequence" do
    it "creates a Sequence" do
      MTK::Patterns.Sequence(1,2,3).should be_a MTK::Patterns::Sequence
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.Sequence(1,2,3).elements.should == [1,2,3]
    end

    it "does not set a type" do
      MTK::Patterns.Sequence(1,2,3).type.should be_nil
    end
  end

  describe "#PitchSequence" do
    it "creates a Sequence" do
      MTK::Patterns.PitchSequence(1,2,3).should be_a MTK::Patterns::Sequence
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.PitchSequence(1,2,3).elements.should == [Pitch(1),Pitch(2),Pitch(3)]
    end

    it "sets #type to :pitch" do
      MTK::Patterns.PitchSequence([]).type.should == :pitch
    end
  end

  describe "#IntensitySequence" do
    it "creates a Sequence" do
      MTK::Patterns.IntensitySequence(1,2,3).should be_a MTK::Patterns::Sequence
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.IntensitySequence(1,2,3).elements.should == [Intensity(1),Intensity(2),Intensity(3)]
    end

    it "sets #type to :intensity" do
      MTK::Patterns.IntensitySequence([]).type.should == :intensity
    end
  end

  describe "#DurationSequence" do
    it "creates a Sequence" do
      MTK::Patterns.DurationSequence(1,2,3).should be_a MTK::Patterns::Sequence
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.DurationSequence(1,2,3).elements.should == [Duration(1),Duration(2),Duration(3)]
    end

    it "sets #type to :duration" do
      MTK::Patterns.DurationSequence([]).type.should == :duration
    end
  end

end