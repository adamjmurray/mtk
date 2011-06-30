require 'spec_helper'

describe MTK::Pattern::Palindrome do

  PALINDROME = MTK::Pattern::Palindrome

  describe "#next" do
    it "reverses direction when the ends of the list are reached" do
      palindrome = PALINDROME.new [1,2,3,4]
      nexts = []
      12.times { nexts << palindrome.next }
      nexts.should == [1,2,3, 4,3,2, 1,2,3, 4,3,2]
    end

    it "reverses direction when the end of the list is reached, and repeats the end (first/last) elements" do
      palindrome = PALINDROME.new [1,2,3,4], :repeat_ends => true
      nexts = []
      12.times { nexts << palindrome.next }
      nexts.should == [1,2,3,4, 4,3,2,1, 1,2,3,4]
    end

    it "enumerates nested sequences" do
      palindrome = PALINDROME.new [1, MTK::Pattern.Sequence(2,3), 4]
      nexts = []
      10.times { nexts << palindrome.next }
      nexts.should == [1,2,3,4, 2,3,1, 2,3,4] # note sequence goes forward in both directions!
    end

    it "enumerates nested sequences, and repeats the last element" do
      palindrome = PALINDROME.new [1, MTK::Pattern.Sequence(2,3), 4], :repeat_ends => true
      nexts = []
      9.times { nexts << palindrome.next }
      nexts.should == [1,2,3,4, 4,2,3,1, 1] # note sequence goes forward in both directions!
    end
  end

  describe "#rewind" do
    it "restarts the Palindrome" do
      palindrome = PALINDROME.new [1,2,3,4]
      5.times { palindrome.next }
      palindrome.rewind
      palindrome.next.should == 1
      palindrome.next.should == 2
    end
  end

  describe "#repeat_ends?" do
    it "is true if the :repeat_ends option is true" do
      PALINDROME.new([], :repeat_ends => true).repeat_ends?.should be_true
    end

    it "is false if the :repeat_ends option is true" do
      PALINDROME.new([], :repeat_ends => false).repeat_ends?.should be_false
    end
  end

  describe "#==" do
    it "is false if the :repeat_ends options are different" do
      PALINDROME.new([1,2,3], :repeat_ends => true).should_not == PALINDROME.new([1,2,3], :repeat_ends => false)
    end
  end

end


describe MTK::Pattern do

  describe "#Palindrome" do
    it "creates a Palindrome" do
      MTK::Pattern.Palindrome(1,2,3).should be_a MTK::Pattern::Palindrome
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.Palindrome(1,2,3).elements.should == [1,2,3]
    end

    it "does not set a type" do
      MTK::Pattern.Palindrome(1,2,3).type.should be_nil
    end
  end

  describe "#PitchPalindrome" do
    it "creates a Palindrome" do
      MTK::Pattern.PitchPalindrome(1,2,3).should be_a MTK::Pattern::Palindrome
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.PitchPalindrome(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.PitchPalindrome([]).type.should == :pitch
    end
  end

  describe "#IntensityPalindrome" do
    it "creates a Palindrome" do
      MTK::Pattern.IntensityPalindrome(1,2,3).should be_a MTK::Pattern::Palindrome
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.IntensityPalindrome(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.IntensityPalindrome([]).type.should == :intensity
    end
  end

  describe "#DurationPalindrome" do
    it "creates a Palindrome" do
      MTK::Pattern.DurationPalindrome(1,2,3).should be_a MTK::Pattern::Palindrome
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.DurationPalindrome(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.DurationPalindrome([]).type.should == :duration
    end
  end

end