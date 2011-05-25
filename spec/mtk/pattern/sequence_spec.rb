require 'spec_helper'

describe MTK::Pattern::Sequence do

  let(:elements) { [1, 2, 3] }
  let(:sequence) { Pattern::Sequence.new elements }

  describe "#next" do
    it "iterates through the list of elements and emits them one at a time" do
      sequence.next.should == elements[0]
      sequence.next.should == elements[1]
      sequence.next.should == elements[2]
    end

    it "starts at the beginning of the list of elements after the end of the list is reached" do
      elements.length.times do
        sequence.next
      end
      sequence.next.should == elements.first
    end

    it "returns the previous return value when nils are encountered" do
      sequence = Pattern::Sequence.new [1, nil]
      sequence.next
      sequence.next.should == 1
    end

    it "returns nil for a nil first item, when no default value was provided at construction" do
      sequence = Pattern::Sequence.new [nil]
      sequence.next.should be_nil
    end

    it "returns the default item for a nil first item, when a default value was provided" do
      sequence = Pattern::Sequence.new [nil], :default_value
      sequence.next.should == :default_value
    end

    it "evaluates any lambdas in the elements list, passing in the previous return value" do
      sequence = Pattern::Sequence.new [1, lambda { |prev_val| prev_val*10 }]
      sequence.next
      sequence.next.should == 10
    end

    it "does not require the lambda to have any parameters" do
      sequence = Pattern::Sequence.new [lambda { 42 }]
      sequence.next.should == 42
    end

    it "returns the default item for any lambdas that evaluate to nil" do
      sequence = Pattern::Sequence.new [lambda { nil }], :default_value
      sequence.next.should == :default_value
    end

    it "passed the previous item (which is not necessarily == the previous return value) as the second arg to lambdas that take 2 parameters" do
      arg1, arg2 = nil, nil
      return_5 = lambda { 5 }
      sequence = Pattern::Sequence.new [return_5, lambda { |a1, a2| arg1, arg2=a1, a2 }]
      sequence.next
      sequence.next
      arg1.should == 5
      arg2.should == return_5
    end
  end

  describe "#reset" do
    it "restarts the sequence" do
      (elements.length - 1).times do
        sequence.next
      end
      sequence.reset
      sequence.next.should == elements.first
    end
  end

end
