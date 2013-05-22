require 'spec_helper'

describe MTK::Patterns::Pattern do

  PATTERN = MTK::Patterns::Pattern

  let(:elements) { [1,2,3] }

  describe "#max_elements" do
    it "is the :max_elements option the pattern was constructed with" do
      PATTERN.new([], :max_elements => 1).max_elements.should == 1
    end

    it "is nil by default" do
      PATTERN.new([]).max_elements.should be_nil
    end

    it "causes a StopIteration exception once max_elements have been emitted" do
      pattern = PATTERN.new([:anything], :max_elements => 5)
      5.times { pattern.next }
      lambda { pattern.next }.should raise_error
    end

    it "has max_elements_exceeded once max_elements have been emitted" do
      pattern = PATTERN.new([:anything], :max_elements => 5)
      5.times { pattern.max_elements_exceeded?.should be_false and pattern.next }
      pattern.max_elements_exceeded?.should be_true
      lambda { pattern.next }.should raise_error StopIteration
    end

    it "raises a StopIteration error when a nested pattern has emitted more than max_elements" do
      pattern = PATTERN.new([Patterns.Cycle(1,2)], :max_elements => 5)
      5.times{ pattern.next }
      lambda{ pattern.next }.should raise_error StopIteration
    end
  end

  describe "#==" do
    it "is true if the elements and types are equal" do
      PATTERN.new(elements, :type => :some_type).should == PATTERN.new(elements, :type => :some_type)
    end

    it "is false if the elements are not equal" do
      PATTERN.new(elements, :type => :some_type).should_not == PATTERN.new(elements + [4], :type => :some_type)
    end

    it "is false if the types are not equal" do
      PATTERN.new(elements, :type => :some_type).should_not == PATTERN.new(elements, :type => :another_type)
    end
  end

end
