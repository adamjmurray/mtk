require 'spec_helper'

describe MTK::Patterns::Pattern do

  PATTERN = MTK::Patterns::Pattern

  let(:elements) { [1,2,3] }

  describe "elements" do
    it "is immutable" do
      ->{ PATTERN.new([]).elements << 1 }.should raise_error RuntimeError, /frozen/
    end
  end

  describe "@min_elements" do
    it "is the :min_elements option the pattern was constructed with" do
      PATTERN.new([], min_elements: 1).min_elements.should == 1
    end

    it "is nil by default" do
      PATTERN.new([]).min_elements.should be_nil
    end

    it "prevents a StopIteration error until min_elements have been emitted (overriding max_elements if necessary)" do
      pattern = PATTERN.new([1,2,3], min_elements: 5, max_elements: 3)
      5.times{ pattern.next }
      lambda{ pattern.next }.should raise_error StopIteration
    end

    it "sets exactly how many elements will be emitted when set to the same values as max_elements" do
      pattern = PATTERN.new([1,2,3], min_elements: 5, max_elements: 5)
      5.times{ pattern.next }
      lambda{ pattern.next }.should raise_error StopIteration
    end

    it "is maintained when applying Group operations" do
      PATTERN.new(elements, min_elements: 2).reverse.min_elements.should == 2
    end
  end

  describe '#min_elements_unmet?' do
    it "is true until min_elements have been emitted" do
      pattern = PATTERN.new([:anything], min_elements:  5)
      5.times { pattern.min_elements_unmet?.should be_true and pattern.next }
      pattern.min_elements_unmet?.should be_false
    end

    it "is always false if min_elements is not set" do
      pattern = PATTERN.new([:anything], min_elements: nil)
      5.times { pattern.min_elements_unmet?.should be_false and pattern.next }
    end

    it "is always false if min_elements is 0" do
      pattern = PATTERN.new([:anything], min_elements: 0)
      5.times { pattern.min_elements_unmet?.should be_false and pattern.next }
    end
  end


  describe "@max_elements" do
    it "is the :max_elements option the pattern was constructed with" do
      PATTERN.new([], max_elements: 1).max_elements.should == 1
    end

    it "is nil by default" do
      PATTERN.new([]).max_elements.should be_nil
    end

    it "causes a StopIteration exception once max_elements have been emitted" do
      pattern = PATTERN.new([:anything], max_elements: 5)
      5.times { pattern.next }
      lambda { pattern.next }.should raise_error
    end

    it "raises a StopIteration error when a nested pattern has emitted more than max_elements" do
      pattern = PATTERN.new([Patterns.Cycle(1,2)], max_elements: 5)
      5.times{ pattern.next }
      lambda{ pattern.next }.should raise_error StopIteration
    end

    it "is maintained when applying Group operations" do
      PATTERN.new(elements, max_elements: 2).reverse.max_elements.should == 2
    end
  end


  describe '#max_elements_exceeded?' do
    it "is false until max_elements have been emitted" do
      pattern = PATTERN.new([:anything], max_elements: 5)
      5.times { pattern.max_elements_exceeded?.should be_false and pattern.next }
      pattern.max_elements_exceeded?.should be_true
    end

    it "is always false when max_elements is not set" do
      pattern = PATTERN.new([:anything], max_elements: nil)
      5.times { pattern.max_elements_exceeded?.should be_false and pattern.next }
    end
  end


  describe "@max_cycles" do
    it "is the :max_cycles option the pattern was constructed with" do
      PATTERN.new([], max_cycles: 2).max_cycles.should == 2
    end

    it "is 1 by default" do
      PATTERN.new([]).max_cycles.should == 1
    end

    it "is maintained when applying Group operations" do
      PATTERN.new(elements, max_cycles: 2).reverse.max_cycles.should == 2
    end
  end


  describe "#next" do
    it "raises StopIteration if elements is empty" do
      lambda{ PATTERN.new([]).next }.should raise_error StopIteration
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
