require 'spec_helper'

describe MTK::Patterns::Chain do

  CHAIN = MTK::Patterns::Chain

  describe '#next' do
    it 'combines 2 basic attributes together' do
      chain = CHAIN.new [C,q]
      chain.next.should == [C,q]
    end

    it 'combines 3 basic attributes together' do
      chain = CHAIN.new [C,q,mp]
      chain.next.should == [C,q,mp]
    end

    it 'combines many basic attributes together, including duplicate types' do
      chain = CHAIN.new [C,q,D,h,s,mp,fff]
      chain.next.should == [C,q,D,h,s,mp,fff]
    end

    it 'raises StopIteration after a basic-attribute-only chain has called #next more than once' do
      chain = CHAIN.new [C,q]
      chain.next
      lambda{ chain.next }.should raise_error StopIteration
    end

    it 'combines a basic attribute with a pattern' do
      chain = CHAIN.new [Patterns.Sequence(C,D,E), q]
      chain.next.should == [C,q]
      chain.next.should == [D,q]
      chain.next.should == [E,q]
      lambda{ chain.next }.should raise_error StopIteration
    end

    it 'combines 2 patterns' do
      chain = CHAIN.new [Patterns.Sequence(C,D,E), Patterns.Sequence(w,h,q)]
      chain.next.should == [C,w]
      chain.next.should == [D,h]
      chain.next.should == [E,q]
      lambda{ chain.next }.should raise_error StopIteration
    end

    it 'combines 2 patterns, and returns #next until the last StopIteration of a nested Pattern occurs' do
      chain = CHAIN.new [Patterns.Sequence(C,D,E), Patterns.Sequence(w,h,q,e)]
      chain.next.should == [C,w]
      chain.next.should == [D,h]
      chain.next.should == [E,q]
      chain.next.should == [C,e]
      lambda{ chain.next }.should raise_error StopIteration
    end


    # TODO: more than 2 patterns, and more than 2 + basic attribute(s)


    it 'combines Choice patterns with max_cycles' do
      chain = CHAIN.new [Patterns.Choice(e,s), Patterns.Choice(C,D,E)], max_cycles:100
      100.times do |time|
        attrs = chain.next
        attrs.length.should == 2
        (attrs[0]==e or attrs[0]==s).should be_true
        (attrs[1]==C or attrs[1]==D or attrs[1]==E).should be_true
      end
      lambda{ chain.next }.should raise_error StopIteration
    end

    it 'combines Choice patterns and emits a only single combination of attributes by default' do
      chain = CHAIN.new [Patterns.Choice(e,s), Patterns.Choice(C,D,E)]
      chain.next
      lambda{ chain.next }.should raise_error StopIteration
    end

    it 'flattens attribute lists with nested chains' do
      chain = CHAIN.new( [1, 2, CHAIN.new([3, CHAIN.new([4,5])])] )
      chain.next.should == [1,2,3,4,5]
    end

    it 'throws StopIteration when any subpattern throws StopIteration with max_elements_exceeded' do
      chain = CHAIN.new [Patterns.Sequence(C,D,E,F,G), Patterns.Sequence(w,h,q,e,  max_elements:3)]
      chain.next.should == [C,w]
      chain.next.should == [D,h]
      chain.next.should == [E,q]
      lambda{ chain.next }.should raise_error StopIteration
    end

    it 'throws StopIteration with max_elements_exceeded (edge case actual element length == max_elements)' do
      chain = CHAIN.new [Patterns.Sequence(C,D,E,F,G), Patterns.Sequence(w,h,q,  max_elements:3)]
      chain.next.should == [C,w]
      chain.next.should == [D,h]
      chain.next.should == [E,q]
      lambda{ chain.next }.should raise_error StopIteration
    end
  end

  describe '#rewind' do
    it 'resets the state of the Chain' do
      # compare with the #next, raises StopIteration test above
      chain = CHAIN.new [C,q]
      chain.next
      chain.rewind
      lambda{ chain.next }.should_not raise_error
      lambda{ chain.next }.should raise_error StopIteration
    end
  end
end


describe MTK::Patterns do

  describe "#Chain" do
    it "creates a Chain" do
      MTK::Patterns.Chain(1,2,3).should be_a MTK::Patterns::Chain
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.Chain(1,2,3).elements.should == [1,2,3]
    end

    it "is includeable" do
      class PatternsIncluder
        include MTK::Patterns
      end
      pat = nil
      PatternsIncluder.new.instance_eval{ pat = Chain(1,2,3) }
      pat.should be_a MTK::Patterns::Chain
      pat.elements.should == [1, 2, 3]
    end
  end

  # TODO: test the other chain builder methods (e.g. PitchChain) in Patterns module
end