require 'spec_helper'

describe MTK::Pattern::Function do

  FUNCTION = MTK::Pattern::Function

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

    it "calls a 2-arg lambda with the previous value and element count (starting from 0)" do
      function = FUNCTION.new lambda{|prev,index| [prev,index] }
      function.next.should == [nil, 0]
      function.next.should == [[nil,0], 1]
      function.next.should == [[[nil,0],1], 2]
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


describe MTK::Pattern do

  describe "#Function" do
    it "creates a Function" do
      MTK::Pattern.Function(nil).should be_a MTK::Pattern::Function
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.Function(:mock_lambda).elements.should == :mock_lambda
    end

    it "does not set a type" do
      MTK::Pattern.Function(:mock_lambda).type.should be_nil
    end

    it "doesn't wrap a lambda in the varargs Array" do
      function = MTK::Pattern.Function( lambda{ 1 + 1 } )
      function.next.should == 2
    end
  end

  describe "#PitchFunction" do
    it "creates a Function" do
      MTK::Pattern.PitchFunction(:mock_lambda).should be_a MTK::Pattern::Function
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.PitchFunction(:mock_lambda).elements.should == :mock_lambda
    end

    it "sets #type to :pitch" do
      MTK::Pattern.PitchFunction([]).type.should == :pitch
    end
  end

  describe "#IntensityFunction" do
    it "creates a Function" do
      MTK::Pattern.IntensityFunction(:mock_lambda).should be_a MTK::Pattern::Function
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.IntensityFunction(:mock_lambda).elements.should == :mock_lambda
    end

    it "sets #type to :pitch" do
      MTK::Pattern.IntensityFunction([]).type.should == :intensity
    end
  end

  describe "#DurationFunction" do
    it "creates a Function" do
      MTK::Pattern.DurationFunction(:mock_lambda).should be_a MTK::Pattern::Function
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.DurationFunction(:mock_lambda).elements.should == :mock_lambda
    end

    it "sets #type to :pitch" do
      MTK::Pattern.DurationFunction([]).type.should == :duration
    end
  end

end