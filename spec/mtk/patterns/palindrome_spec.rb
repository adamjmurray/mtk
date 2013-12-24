require 'spec_helper'

describe MTK::Patterns::Palindrome do

  PALINDROME = MTK::Patterns::Palindrome

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
      palindrome = PALINDROME.new [1, MTK::Patterns.Sequence(2,3), 4]
      nexts = []
      10.times { nexts << palindrome.next }
      nexts.should == [1,2,3,4, 2,3,1, 2,3,4] # note sequence goes forward in both directions!
    end

    it "enumerates nested sequences, and repeats the last element" do
      palindrome = PALINDROME.new [1, MTK::Patterns.Sequence(2,3), 4], :repeat_ends => true
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


describe MTK::Patterns do

  describe "#Palindrome" do
    it "creates a Palindrome" do
      MTK::Patterns.Palindrome(1,2,3).should be_a MTK::Patterns::Palindrome
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.Palindrome(1,2,3).elements.should == [1,2,3]
    end

    it "is includeable" do
      class PatternsIncluder
        include MTK::Patterns
      end
      pat = nil
      PatternsIncluder.new.instance_eval{ pat = Palindrome(1,2,3) }
      pat.should be_a MTK::Patterns::Palindrome
      pat.elements.should == [1, 2, 3]
    end
  end

  describe "#PitchPalindrome" do
    it "creates a Palindrome" do
      MTK::Patterns.PitchPalindrome(1,2,3).should be_a MTK::Patterns::Palindrome
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.PitchPalindrome(1,2,3).elements.should == [Pitch(1),Pitch(2),Pitch(3)]
    end
  end

  describe "#IntensityPalindrome" do
    it "creates a Palindrome" do
      MTK::Patterns.IntensityPalindrome(1,2,3).should be_a MTK::Patterns::Palindrome
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.IntensityPalindrome(1,2,3).elements.should == [Intensity(1),Intensity(2),Intensity(3)]
    end
  end

  describe "#DurationPalindrome" do
    it "creates a Palindrome" do
      MTK::Patterns.DurationPalindrome(1,2,3).should be_a MTK::Patterns::Palindrome
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.DurationPalindrome(1,2,3).elements.should == [Duration(1),Duration(2),Duration(3)]
    end
  end

end