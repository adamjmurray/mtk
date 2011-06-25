require 'spec_helper'

describe MTK::Collection do

  class MockCollection
    include MTK::Collection
    attr_reader :elements
    def initialize(elements); @elements = elements end
    def self.from_a(enumerable); new(enumerable) end
  end

  let(:elements) { [1,2,3,4,5] }
  let(:collection) { MockCollection.new elements }

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
  end

  describe "#clone" do
    it "creates an equal collection" do
      collection.clone.should == collection
    end

    it "creates a new collection" do
      collection.clone.should_not equal collection
    end
  end

end