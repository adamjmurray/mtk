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
      chain = CHAIN.new [Patterns.Sequence(C,D,E), Patterns.Sequence(w,h,q,i)]
      chain.next.should == [C,w]
      chain.next.should == [D,h]
      chain.next.should == [E,q]
      chain.next.should == [C,i]
      lambda{ chain.next }.should raise_error StopIteration
    end

    # TODO: more than 2 patterns, and more than 2 + basic attribute(s)

  end

  describe '#rewind' do
    it 'resets the state of the Chain' do
      # compare with the #next, raises StopIteration test above
      chain = CHAIN.new [C,q]
      chain.next
      chain.rewind
      lambda{ chain.next }.should_not raise_error StopIteration
      lambda{ chain.next }.should raise_error StopIteration
    end
  end

  # TODO: test the chain builder method in Patterns module

end
