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

end
