require 'spec_helper'

describe MTK::Patterns::Function do

  FUNCTION = MTK::Patterns::Function

  describe "#next" do
    it "calls a lambda to produce elements" do
      function = FUNCTION.new lambda{ 1 + 1 }
      function.next.should == 2
      function.next.should == 2
    end

    it "calls a 1-arg lambda with the previous value" do
      function = FUNCTION.new lambda{|prev| (prev || 0) + 1 }
      function.next.should == 1
      function.next.should == 2
      function.next.should == 3
    end

    it "stops looping when the lambda raises StopIteration" do
      function = FUNCTION.new lambda{|prev| raise StopIteration if prev == 2; (prev || 0) + 1 }
      nexts = []
      loop do
        nexts << function.next
      end
      nexts.should == [1,2]
    end

    it "calls a 2-arg lambda with the previous value and function call count (starting from 0)" do
      function = FUNCTION.new lambda{|prev,index| [prev,index] }
      function.next.should == [nil, 0]
      function.next.should == [[nil,0], 1]
      function.next.should == [[[nil,0],1], 2]
    end

    it "calls a 3-arg lambda with the previous value, function call count (starting from 0), and element count (starting from 0)" do
      function = FUNCTION.new lambda{|prev,call_index,elem_index| prev.nil? ? MTK::Patterns.Sequence(1,2,3,4) : [call_index,elem_index] }
      function.next.should == 1
      function.next.should == 2
      function.next.should == 3
      function.next.should == 4
      function.next.should == [1,4]
    end

    it "can generate other Patterns, which will be iterated over before re-calling the function" do
      function = FUNCTION.new lambda{|prev,index| MTK::Patterns.Sequence(index,2,3) }
      function.next.should == 0
      function.next.should == 2
      function.next.should == 3
      function.next.should == 1 # end of sequence, now a new one is generated, this time starting with 1
      function.next.should == 2
      function.next.should == 3
    end
  end

  describe "#rewind" do
    it "resets previous value and element count" do
      function = FUNCTION.new lambda{|prev,index| [prev,index] }
      function.next.should == [nil, 0]
      function.next.should == [[nil,0], 1]
      function.rewind
      function.next.should == [nil, 0]
    end
  end

end


describe MTK::Patterns do

  describe "#Function" do
    it "creates a Function" do
      MTK::Patterns.Function(nil).should be_a MTK::Patterns::Function
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.Function(:mock_lambda).function.should == :mock_lambda
    end

    it "does not set a type" do
      MTK::Patterns.Function(:mock_lambda).type.should be_nil
    end

    it "doesn't wrap a lambda in the varargs Array" do
      function = MTK::Patterns.Function( lambda{ 1 + 1 } )
      function.next.should == 2
    end
  end

  describe "#PitchFunction" do
    it "creates a Function" do
      MTK::Patterns.PitchFunction(:mock_lambda).should be_a MTK::Patterns::Function
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.PitchFunction(:mock_lambda).function.should == :mock_lambda
    end

    it "sets #type to :pitch" do
      MTK::Patterns.PitchFunction([]).type.should == :pitch
    end
  end

  describe "#IntensityFunction" do
    it "creates a Function" do
      MTK::Patterns.IntensityFunction(:mock_lambda).should be_a MTK::Patterns::Function
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.IntensityFunction(:mock_lambda).function.should == :mock_lambda
    end

    it "sets #type to :pitch" do
      MTK::Patterns.IntensityFunction([]).type.should == :intensity
    end
  end

  describe "#DurationFunction" do
    it "creates a Function" do
      MTK::Patterns.DurationFunction(:mock_lambda).should be_a MTK::Patterns::Function
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.DurationFunction(:mock_lambda).function.should == :mock_lambda
    end

    it "sets #type to :pitch" do
      MTK::Patterns.DurationFunction([]).type.should == :duration
    end
  end

end