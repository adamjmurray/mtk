require 'spec_helper'

describe MTK::Groups::Group do

  GROUP = MTK::Groups::Group
  
  class GroupWithOptions < MTK::Groups::Group
    attr_reader :options
    def initialize(elements, options={})
      @elements = elements
      @options = options
    end
    def self.from_a(elements, options={})
      new(elements, options)
    end
  end

  let(:elements) { [1,2,3,4,5] }
  let(:group) { GROUP.new elements }

  let(:options) { {:opt1 => :val1, :opt2 => :val2} }
  let(:group_with_options) { GroupWithOptions.new(elements, options) }

  it "is Enumerable" do
    group.should be_a Enumerable
  end

  describe "#to_a" do
    it "is the the Array of elements in the group" do
      group.to_a.should == elements
    end
  end

  describe "#size" do
    it "is the length of the elements" do
      group.size.should == elements.length
    end
  end

  describe "#length" do
    it "acts like #size" do
      group.length.should == group.size
    end
  end

  describe "#empty?" do
    it "is true when elements is nil" do
      GROUP.new(nil).empty?.should be_true
    end

    it "is true when elements is empty" do
      GROUP.new([]).empty?.should be_true
    end

    it "is false when elements is not empty" do
      GROUP.new([1]).empty?.should be_false
    end
  end

  describe "#each" do
    it "yields each element" do
      yielded = []
      group.each do |element|
        yielded << element
      end
      yielded.should == elements
    end
  end

  describe "#map" do
    it "returns a Group with each item replaced with the results of the block" do
      group.map{|item| item + 10}.should == [11, 12, 13, 14, 15]
    end

    it "maintains the options from the original group" do
      group_with_options.map{|item| item + 10}.options.should == options
    end
  end

  describe "#first" do
    it "is #[0] when no argument is given" do
      group.first.should == group[0]
    end

    it "is the first n elements, for an argument n" do
      group.first(3).should == elements[0..2]
    end

    it "is the elements when n is bigger than elements.length, for an argument n" do
      group.first(elements.length * 2).should == elements
    end
  end

  describe "#last" do
    it "is #[-1] when no argument is given" do
      group.last.should == group[-1]
    end

    it "is the last n elements, for an argument n" do
      group.last(3).should == elements[-3..-1]
    end

    it "is the elements when n is bigger than elements.length, for an argument n" do
      group.last(elements.length * 2).should == elements
    end
  end

  describe "#random" do
    it "returns a random element" do
      # There's a slight chance this will fail due to the random nature, just run again...
      elements = []
      1_000_000.times{|i| elements << i }
      group = GROUP.new(elements)
      prev = nil
      3.times do
        random = group.random
        random.should >= 0
        random.should < 1_000_000
        random.should_not == prev
        prev = random
      end
    end
  end

  describe "#[]" do
    it "accesses an element by index" do
      group[3].should == elements[3]
    end

    it "supports negative indexes" do
      group[-1].should == elements[-1]
    end

    it "accesses ranges of elements" do
      group[0..3].should == elements[0..3]
    end
  end

  describe "#repeat" do
    it "repeats the elements the number of times given by the argument" do
      group.repeat(3).should == [1,2,3,4,5,1,2,3,4,5,1,2,3,4,5]
    end

    it "repeats the elements twice if no argument is given" do
      group.repeat.should == [1,2,3,4,5,1,2,3,4,5]
    end

    it "handles fractional repetitions" do
      group.repeat(1.6).should == [1,2,3,4,5,1,2,3]
    end

    it "returns an instance of the same type" do
      group.repeat.should be_a group.class
    end

    it "does not modify the original group" do
      group.repeat.should_not equal group
    end

    it "maintains the options from the original group" do
      group_with_options.repeat.options.should == options
    end
  end

  describe "#permute" do
    it "randomly rearranges the order of elements" do
      elements = (0..1000).to_a
      permuted = GROUP.new(elements).permute
      permuted.should_not == elements
      permuted.sort.should == elements
    end

    it "returns an instance of the same type" do
      group.permute.should be_a group.class
    end

    it "does not modify the original group" do
      group.permute.should_not equal group
    end

    it "maintains the options from the original group" do
      group_with_options.permute.options.should == options
    end
  end

  describe "#shuffle" do
    it "behaves like #permute" do
      elements = (0..1000).to_a
      shuffled = GROUP.new(elements).shuffle
      shuffled.should_not == elements
      shuffled.sort.should == elements
    end

    it "returns an instance of the same type" do
      group.shuffle.should be_a group.class
    end

    it "does not modify the original group" do
      group.shuffle.should_not equal group
    end

    it "maintains the options from the original group" do
      group_with_options.shuffle.options.should == options
    end
  end

  describe "#rotate" do
    it "produces a Group that is rotated right by the given positive offset" do
      group.rotate(2).should == [3,4,5,1,2]
    end

    it "produces a Group that is rotated left by the given negative offset" do
      group.rotate(-2).should == [4,5,1,2,3]
    end

    it "rotates by 1 if no argument is given" do
      group.rotate.should == [2,3,4,5,1]
    end

    it "returns an instance of the same type" do
      group.rotate.should be_a group.class
    end

    it "does not modify the original group" do
      group.rotate.should_not equal group
    end

    it "maintains the options from the original group" do
      group_with_options.rotate.options.should == options
    end
  end

  describe "#concat" do
    it "appends the argument to the elements" do
      group.concat([6,7]).should == [1,2,3,4,5,6,7]
    end

    it "returns an instance of the same type" do
      group.concat([6,7]).should be_a group.class
    end

    it "does not modify the original group" do
      group.concat([6,7]).should_not equal group
    end

    it "maintains the options from the original (receiver) group" do
      group_with_options.concat([6,7]).options.should == options
    end

    it "ignored any options from the argument group" do
      # I considered merging the options, but it seems potentially too confusing, so
      # we'll go with this simpler behavior until a use-case appears where this is inappropriate.
      arg = GroupWithOptions.new(elements, :opt1 => :another_val, :opt3 => :val3)
      group_with_options.concat(arg).options.should == options
    end
  end

  describe "#reverse" do
    it "reverses the elements" do
      group.reverse.should == elements.reverse
    end

    it "returns an instance of the same type" do
      group.reverse.should be_a group.class
    end

    it "does not modify the original group" do
      group.reverse.should_not equal group
    end

    it "maintains the options from the original group" do
      group_with_options.reverse.options.should == options
    end
  end

  describe "#partition" do
    # TODO: better descriptions! (and document the method too!)

    context "Numeric argument" do
      it "partitions the elements into groups of the size, plus whatever's left over as the last element" do
        group.partition(2).should == [
          GROUP.new([1,2]),
          GROUP.new([3,4]),
          GROUP.new([5])
        ]
      end
    end

    context "Array argument" do
      it "partitions the elements into groups of the size of the argument elements" do
        group.partition([1,2,2]).should == [
          GROUP.new([1]),
          GROUP.new([2,3]),
          GROUP.new([4,5])
        ]
      end

      it "does not include leftover elements" do
        group.partition([1,3]).should == [
          GROUP.new([1]),
          GROUP.new([2,3,4])
        ]
      end

      it "does not include extra elements" do
        group.partition([1,5]).should == [
          GROUP.new([1]),
          GROUP.new([2,3,4,5])
        ]
      end
    end

    context "no argument, block given" do
      it "partitions the elements into groups with the same block return value" do
        group.partition{|item| item % 3 }.should =~ [
          GROUP.new([1,4]),
          GROUP.new([2,5]),
          GROUP.new([3])
        ]
      end

      it "optionally passes the item index into the block" do
        group.partition{|item,index| (item*index) % 3 }.should =~ [
          # 1*0, 2*1, 3*2, 4*3, 5*4 => (0, 2, 6, 12, 20) % 3 => 0, 2, 0, 0, 2
          GROUP.new([1,3,4]),
          GROUP.new([2,5]),
        ]
      end
    end

    context "incompatible / missing argument, no block given" do
      it "returns self" do
        group.partition.should == group
      end
    end

  end

  describe "#==" do
    it "is true when the elements in 2 Groups are equal" do
      group.should == GROUP.new(elements)
    end

    it "is true when the elements equal the argument" do
      group.should == elements
    end

    it "is false when the elements in 2 Groups are not equal" do
      group.should_not == GROUP.new(elements + [1,2])
    end

    it "is false when the elements do not equal the argument" do
      group.should_not == (elements + [1,2])
    end

    it "is false when the options are not equal" do
      group.should_not == group_with_options
    end
  end

  describe "#clone" do
    it "creates an equal group" do
      group.clone.should == group
    end

    it "creates a new group" do
      group.clone.should_not equal group
    end

    it "maintains the options from the original group" do
      group_with_options.clone.options.should == options
    end
  end

  describe "#to_s" do
    it 'is "[#{elem0.to_s}, #{elem1.to_s}, ..., #{elemN.to_s}]"' do
      group.to_s.should == "[1, 2, 3, 4, 5]"
    end
  end

  describe "#inspect" do
    it 'is "#<#{GroupClassName}: [#{elem0.to_s}, #{elem1.to_s}, ..., #{elemN.to_s}]>"' do
      group.inspect.should == "#<Group: [1, 2, 3, 4, 5]>"
    end
  end
  
  describe "Array#+= MTK::Group" do
    it 'concatenates the elements of the Group to the Array' do
      array = [10]
      array += group
      array.should == [10,1,2,3,4,5]
    end
  end

end
