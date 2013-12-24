require 'spec_helper'

describe MTK::Patterns::Sequence do

  SEQUENCE = MTK::Patterns::Sequence

  let(:elements) { [1,2,3] }
  let(:sequence) { SEQUENCE.new(elements) }

  it "is a MTK::Group" do
    sequence.should be_a MTK::Groups::Group
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

  describe "@min_elements" do
    it "prevents a StopIteration error until min_elements have been emitted" do
      pattern = SEQUENCE.new([1,2,3], cycle_count: 1, min_elements: 5)
      5.times{ pattern.next }
      lambda{ pattern.next }.should raise_error StopIteration
    end
  end


  describe "@max_cycles" do
    it "is the :max_cycles option the pattern was constructed with" do
      SEQUENCE.new( [], max_cycles: 2 ).max_cycles.should == 2
    end

    it "is 1 by default" do
      SEQUENCE.new( [] ).max_cycles.should == 1
    end

    it "loops indefinitely when it's nil" do
      sequence = SEQUENCE.new( [1], max_cycles: nil )
      lambda { 100.times { sequence.next } }.should_not raise_error
    end

    it "causes a StopIteration exception after the number of cycles has completed" do
      sequence = SEQUENCE.new( elements, max_cycles: 2 )
      2.times do
        elements.length.times { sequence.next } # one full cycle
      end
      lambda { sequence.next }.should raise_error StopIteration
    end
  end


  describe "#max_cycles_exceeded?" do
    it "is false until max_elements have been emitted" do
      sequence = SEQUENCE.new( elements, max_cycles: 2 )
      2.times do
        sequence.max_cycles_exceeded?.should be_false
        elements.length.times { sequence.next } # one full cycle
      end
      # unlike with element_count and max_elements_exceeded?, cycle_count doesn't get bumped until
      # you ask for the next element and a StopIteration is thrown
      lambda { sequence.next }.should raise_error StopIteration
      sequence.max_cycles_exceeded?.should be_true
    end

    it "is always false when max_cycles is not set" do
      pattern = PATTERN.new([:anything], max_cycles: nil)
      15.times { pattern.max_cycles_exceeded?.should be_false and pattern.next }
    end
  end


  it "has max_elements_exceeded once max_elements have been emitted (edge case, has same number of elements)" do
    sequence = SEQUENCE.new([1,2,3,4,5], :max_elements => 5)
    5.times { sequence.max_elements_exceeded?.should(be_false) and sequence.next }
    sequence.max_elements_exceeded?.should be_true
    lambda { sequence.next }.should raise_error StopIteration
  end


  it "raises a StopIteration error when a nested pattern has emitted more than max_elements" do
    sequence = SEQUENCE.new([Patterns.Cycle(1,2)], :max_elements => 5)
    5.times { sequence.next }
    lambda{ sequence.next }.should raise_error StopIteration
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

    it "is includeable" do
      class PatternsIncluder
        include MTK::Patterns
      end
      pat = nil
      PatternsIncluder.new.instance_eval{ pat = Sequence(1,2,3) }
      pat.should be_a MTK::Patterns::Sequence
      pat.elements.should == [1, 2, 3]
    end
  end

  describe "#PitchSequence" do
    it "creates a Sequence" do
      MTK::Patterns.PitchSequence(1,2,3).should be_a MTK::Patterns::Sequence
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.PitchSequence(1,2,3).elements.should == [Pitch(1),Pitch(2),Pitch(3)]
    end
  end

  describe "#IntensitySequence" do
    it "creates a Sequence" do
      MTK::Patterns.IntensitySequence(1,2,3).should be_a MTK::Patterns::Sequence
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.IntensitySequence(1,2,3).elements.should == [Intensity(1),Intensity(2),Intensity(3)]
    end
  end

  describe "#DurationSequence" do
    it "creates a Sequence" do
      MTK::Patterns.DurationSequence(1,2,3).should be_a MTK::Patterns::Sequence
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.DurationSequence(1,2,3).elements.should == [Duration(1),Duration(2),Duration(3)]
    end
  end

end