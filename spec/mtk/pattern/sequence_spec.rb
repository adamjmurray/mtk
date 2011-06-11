require 'spec_helper'

describe MTK::Pattern::Sequence do

  let(:elements) { [1,2,3] }
  let(:sequence) { Pattern::Sequence.new(elements) }

  describe "#elements" do
    it "is the array the sequence was constructed with" do
      sequence.elements.should == elements
    end
  end

  describe "#repeat" do
    it "repeats the sequence the number of times given by the argument" do
      sequence.repeat(3).should == [1,2,3,1,2,3,1,2,3]
    end

    it "repeats the sequence twice if no argument is given" do
      sequence.repeat.should == [1,2,3,1,2,3]
    end

    it "handles fractional repetitions" do
      sequence.repeat(2.67).should == [1,2,3,1,2,3,1,2]
    end
  end

end
