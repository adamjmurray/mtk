require 'spec_helper'

describe MTK::Pattern::AbstractPattern do

  PATTERN = MTK::Pattern::AbstractPattern

  describe "#next" do
    it "sets mtk_type to the pattern's type, for elements with a nil mtk_type field" do
      # Numeric has been enhanced with an mtk_type field, so we can distinguish intensity from duration
      PATTERN.new([5], :type => :intensity).next.mtk_type.should == :intensity
    end
  end

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

end
