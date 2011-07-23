require 'spec_helper'

describe MTK::Helper::Collection do

  class MockCollection
    include MTK::Helper::Collection
    attr_reader :elements
    def initialize(elements); @elements = elements end
    def self.from_a(elements); new(elements) end
  end

  class MockCollectionWithOptions
    include MTK::Helper::Collection
    attr_reader :elements, :options
    def initialize(elements, options={})
      @elements = elements
      @options = options
    end
    def self.from_a(elements, options={})
      new(elements, options)
    end
  end

  let(:elements) { [1,2,3,4,5] }
  let(:collection) { MockCollection.new elements }

  let(:options) { {:opt1 => :val1, :opt2 => :val2} }
  let(:collection_with_options) { MockCollectionWithOptions.new(elements, options) }

  it "is Enumerable" do
    collection.should be_a Enumerable
  end

  describe "#to_a" do
    it "is the the Array of elements in the collection" do
      collection.to_a.should == elements
    end
  end

  describe "#size" do
    it "is the length of the elements" do
      collection.size.should == elements.length
    end
  end

  describe "#length" do
    it "acts like #size" do
      collection.length.should == collection.size
    end
  end

  describe "#empty?" do
    it "is true when elements is nil" do
      MockCollection.new(nil).empty?.should be_true
    end

    it "is true when elements is empty" do
      MockCollection.new([]).empty?.should be_true
    end

    it "is false when elements is not empty" do
      MockCollection.new([1]).empty?.should be_false
    end
  end

  describe "#each" do
    it "yields each element" do
      yielded = []
      collection.each do |element|
        yielded << element
      end
      yielded.should == elements
    end
  end

  describe "#first" do
    it "is #[0] when no argument is given" do
      collection.first.should == collection[0]
    end

    it "is the first n elements, for an argument n" do
      collection.first(3).should == elements[0..2]
    end

    it "is the elements when n is bigger than elements.length, for an argument n" do
      collection.first(elements.length * 2).should == elements
    end
  end

  describe "#last when no argument is given" do
    it "is #[-1]" do
      collection.last.should == collection[-1]
    end

    it "is the last n elements, for an argument n" do
      collection.last(3).should == elements[-3..-1]
    end

    it "is the elements when n is bigger than elements.length, for an argument n" do
      collection.last(elements.length * 2).should == elements
    end
  end

  describe "#[]" do
    it "accesses an element by index" do
      collection[3].should == elements[3]
    end

    it "supports negative indexes" do
      collection[-1].should == elements[-1]
    end

    it "accesses ranges of elements" do
      collection[0..3].should == elements[0..3]
    end
  end

  describe "#repeat" do
    it "repeats the elements the number of times given by the argument" do
      collection.repeat(3).should == [1,2,3,4,5,1,2,3,4,5,1,2,3,4,5]
    end

    it "repeats the elements twice if no argument is given" do
      collection.repeat.should == [1,2,3,4,5,1,2,3,4,5]
    end

    it "handles fractional repetitions" do
      collection.repeat(1.6).should == [1,2,3,4,5,1,2,3]
    end

    it "returns an instance of the same type" do
      collection.repeat.should be_a collection.class
    end

    it "does not modify the original collection" do
      collection.repeat.should_not equal collection
    end

    it "maintains the options from the original collection" do
      collection_with_options.repeat.options.should == options
    end
  end

  describe "#permute" do
    it "randomly rearranges the order of elements" do
      elements = (0..1000).to_a
      permuted = MockCollection.new(elements).permute
      permuted.should_not == elements
      permuted.sort.should == elements
    end

    it "returns an instance of the same type" do
      collection.permute.should be_a collection.class
    end

    it "does not modify the original collection" do
      collection.permute.should_not equal collection
    end

    it "maintains the options from the original collection" do
      collection_with_options.permute.options.should == options
    end
  end

  describe "#shuffle" do
    it "behaves like #permute" do
      elements = (0..1000).to_a
      shuffled = MockCollection.new(elements).shuffle
      shuffled.should_not == elements
      shuffled.sort.should == elements
    end

    it "returns an instance of the same type" do
      collection.shuffle.should be_a collection.class
    end

    it "does not modify the original collection" do
      collection.shuffle.should_not equal collection
    end

    it "maintains the options from the original collection" do
      collection_with_options.shuffle.options.should == options
    end
  end

  describe "#rotate" do
    it "produces a Collection that is rotated right by the given positive offset" do
      collection.rotate(2).should == [3,4,5,1,2]
    end

    it "produces a Collection that is rotated left by the given negative offset" do
      collection.rotate(-2).should == [4,5,1,2,3]
    end

    it "rotates by 1 if no argument is given" do
      collection.rotate.should == [2,3,4,5,1]
    end

    it "returns an instance of the same type" do
      collection.rotate.should be_a collection.class
    end

    it "does not modify the original collection" do
      collection.rotate.should_not equal collection
    end

    it "maintains the options from the original collection" do
      collection_with_options.rotate.options.should == options
    end
  end

  describe "#concat" do
    it "appends the argument to the elements" do
      collection.concat([6,7]).should == [1,2,3,4,5,6,7]
    end

    it "returns an instance of the same type" do
      collection.concat([6,7]).should be_a collection.class
    end

    it "does not modify the original collection" do
      collection.concat([6,7]).should_not equal collection
    end

    it "maintains the options from the original (receiver) collection" do
      collection_with_options.concat([6,7]).options.should == options
    end

    it "ignored any options from the argument collection" do
      # I considered merging the options, but it seems potentially too confusing, so
      # we'll go with this simpler behavior until a use-case appears where this is inappropriate.
      arg = MockCollectionWithOptions.new(elements, :opt1 => :another_val, :opt3 => :val3)
      collection_with_options.concat(arg).options.should == options
    end
  end

  describe "#reverse" do
    it "reverses the elements" do
      collection.reverse.should == elements.reverse
    end

    it "returns an instance of the same type" do
      collection.reverse.should be_a collection.class
    end

    it "does not modify the original collection" do
      collection.reverse.should_not equal collection
    end

    it "maintains the options from the original collection" do
      collection_with_options.reverse.options.should == options
    end
  end

  describe "#partition" do
    # TODO: better descriptions! (and document the method too!)

    context "Numeric argument" do
      it "partitions the elements into groups of the size, plus whatever's left over as the last element" do
        collection.partition(2).should == [
          MockCollection.new([1,2]),
          MockCollection.new([3,4]),
          MockCollection.new([5])
        ]
      end
    end

    context "Array argument" do
      it "partitions the elements into groups of the size of the argument elements" do
        collection.partition([1,2,2]).should == [
          MockCollection.new([1]),
          MockCollection.new([2,3]),
          MockCollection.new([4,5])
        ]
      end

      it "does not include leftover elements" do
        collection.partition([1,3]).should == [
          MockCollection.new([1]),
          MockCollection.new([2,3,4])
        ]
      end

      it "does not include extra elements" do
        collection.partition([1,5]).should == [
          MockCollection.new([1]),
          MockCollection.new([2,3,4,5])
        ]
      end
    end

    context "no argument, block given" do
      it "partitions the elements into groups with the same block return value" do
        collection.partition{|item| item % 3 }.should =~ [
          MockCollection.new([1,4]),
          MockCollection.new([2,5]),
          MockCollection.new([3])
        ]
      end

      it "optionally passes the item index into the block" do
        collection.partition{|item,index| (item*index) % 3 }.should =~ [
          # 1*0, 2*1, 3*2, 4*3, 5*4 => (0, 2, 6, 12, 20) % 3 => 0, 2, 0, 0, 2
          MockCollection.new([1,3,4]),
          MockCollection.new([2,5]),
        ]
      end
    end

    context "incompatible / missing argument, no block given" do
      it "returns self" do
        collection.partition.should == collection
      end
    end

  end

  describe "#==" do
    it "is true when the elements in 2 Collections are equal" do
      collection.should == MockCollection.new(elements)
    end

    it "is true when the elements equal the argument" do
      collection.should == elements
    end

    it "is false when the elements in 2 Collections are not equal" do
      collection.should_not == MockCollection.new(elements + [1,2])
    end

    it "is false when the elements do not equal the argument" do
      collection.should_not == (elements + [1,2])
    end

    it "is false when the options are not equal" do
      collection.should_not == collection_with_options
    end
  end

  describe "#clone" do
    it "creates an equal collection" do
      collection.clone.should == collection
    end

    it "creates a new collection" do
      collection.clone.should_not equal collection
    end

    it "maintains the options from the original collection" do
      collection_with_options.clone.options.should == options
    end
  end

end


describe "Array" do
  describe "#rotate" do
    # test the Ruby 1.8 backport of Array#rotate
    it "should rotate the Array, as in Ruby 1.9's API" do
      [1,2,3].rotate(1).should == [2,3,1]
    end
  end
end