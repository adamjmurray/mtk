require 'spec_helper'

describe MTK::Patterns::Pattern do

  PATTERN = MTK::Patterns::Pattern

  let(:elements) { [1,2,3] }

  describe "#type" do
    it "is the :type value from the constuctor's options hash" do
      PATTERN.new([], :type => :my_type).type.should == :my_type
    end
  end

  describe "#max_elements" do
    it "is the :max_elements option the pattern was constructed with" do
      PATTERN.new([], :max_elements => 1).max_elements.should == 1
    end

    it "is nil by default" do
      PATTERN.new([]).max_elements.should be_nil
    end

    it "causes a StopIteration exception after the number of elements have been emitted" do
      cycle = PATTERN.new([:anything], :max_elements => 5)
      5.times { cycle.next }
      lambda { cycle.next }.should raise_error
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
