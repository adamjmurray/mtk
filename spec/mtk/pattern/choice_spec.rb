require 'spec_helper'
require 'set'

describe MTK::Pattern::Choice do

  CHOICE = MTK::Pattern::Choice

  let(:elements) { [1,2,3] }
  let(:choice) { CHOICE.new elements }

  describe "#next" do
    it "randomly chooses one of the elements" do
      choosen = Set.new
      100.times do
        element = choice.next
        choosen << element
        elements.should include(element)
      end
      choosen.to_a.sort.should == elements
    end

    it "enumerates a choosen sub-sequence" do
      choice = CHOICE.new [MTK::Pattern.Sequence(4,5,6)]
      choice.next.should == 4
      choice.next.should == 5
      choice.next.should == 6
      choice.next.should == 4 # now it will select a new choice, but there's only one, so it will be the same
      choice.next.should == 5
      choice.next.should == 6
    end
  end

end


describe MTK::Pattern do

  describe "#Choice" do
    it "creates a Choice" do
      MTK::Pattern.Choice(1,2,3).should be_a MTK::Pattern::Choice
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.Choice(1,2,3).elements.should == [1,2,3]
    end

    it "does not set a type" do
      MTK::Pattern.Choice(1,2,3).type.should be_nil
    end
  end

  describe "#PitchChoice" do
    it "creates a Choice" do
      MTK::Pattern.PitchChoice(1,2,3).should be_a MTK::Pattern::Choice
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.PitchChoice(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.PitchChoice([]).type.should == :pitch
    end
  end

  describe "#IntensityChoice" do
    it "creates a Choice" do
      MTK::Pattern.IntensityChoice(1,2,3).should be_a MTK::Pattern::Choice
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.IntensityChoice(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.IntensityChoice([]).type.should == :intensity
    end
  end

  describe "#DurationChoice" do
    it "creates a Choice" do
      MTK::Pattern.DurationChoice(1,2,3).should be_a MTK::Pattern::Choice
    end

    it "sets #elements from the varargs" do
      MTK::Pattern.DurationChoice(1,2,3).elements.should == [1,2,3]
    end

    it "sets #type to :pitch" do
      MTK::Pattern.DurationChoice([]).type.should == :duration
    end
  end

end