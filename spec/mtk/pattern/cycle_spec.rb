require 'spec_helper'

describe MTK::Pattern::Cycle do

  let(:elements) { [1, 2, 3] }
  let(:cycle) { Pattern::Cycle.new elements }

  describe "#next" do
    it "iterates through the list of elements and emits them one at a time" do
      cycle.next.should == elements[0]
      cycle.next.should == elements[1]
      cycle.next.should == elements[2]
    end

    it "starts at the beginning of the list of elements after the end of the list is reached" do
      elements.length.times do
        cycle.next
      end
      cycle.next.should == elements.first
    end

    it "evaluates any lambdas in the elements list, passing in the previous return value" do
      cycle = Pattern::Cycle.new [1, lambda { |prev_val| prev_val*10 }]
      cycle.next
      cycle.next.should == 10
    end

    it "does not require the lambda to have any parameters" do
      cycle = Pattern::Cycle.new [lambda { 42 }]
      cycle.next.should == 42
    end

    it "passed the previous item (which is not necessarily == the previous return value) as the second arg to lambdas that take 2 parameters" do
      arg1, arg2 = nil, nil
      return_5 = lambda { 5 }
      cycle = Pattern::Cycle.new [return_5, lambda { |a1, a2| arg1, arg2=a1, a2 }]
      cycle.next
      cycle.next
      arg1.should == 5
      arg2.should == return_5
    end
  end

  describe "#reset" do
    it "restarts the cycle" do
      (elements.length - 1).times do
        cycle.next
      end
      cycle.reset
      cycle.next.should == elements.first
    end
  end

end
