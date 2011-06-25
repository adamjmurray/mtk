require 'spec_helper'

describe MTK::Pattern::Sequence do

  SEQUENCE = MTK::Pattern::Sequence

  let(:elements) { [1,2,3] }
  let(:sequence) { SEQUENCE.new(elements) }

  it "is a MTK::Collection" do
    sequence.should be_a MTK::Collection
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
  end

end


describe MTK::Pattern do

  describe "#Sequence" do
    it "handles varargs" do
      MTK::Pattern.Sequence(1,2,3).should == MTK::Pattern::Sequence.new([1,2,3])
    end

    include MTK::Pattern
    it "is includeable" do
      Sequence(1,2,3).should == MTK::Pattern::Sequence.new([1,2,3])
    end
  end

end