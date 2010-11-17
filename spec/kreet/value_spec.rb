require 'spec_helper'
module Kreet
  
  describe Value do
  
    let(:value) { 70.5 }
    subject { Value.new(value) }
    let(:lo) { Value.new(0.0) }
    let(:hi) { Value.new(1.0) }
    let(:subjects) { [lo, hi] }
    
    it 'should have Comparable methods' do
      Value.should include Comparable      
      lo.should      < hi
      hi.should_not  > hi
      lo.should     <= lo
      lo.should     <= hi
      hi.should_not <= lo
      lo.should     >= lo
      hi.should     >= lo
      lo.should_not >= hi
      hi.should      > lo
      lo.should_not  > hi
    end
    
    describe '#value' do
      it 'is the value the object was constructed with' do
        subject.value.should == value
      end
    end

    describe '#to_f' do
      it 'is the value as a float' do
        val = Rational(3,5)
        Value.new( val ).to_f.should == val.to_f
      end
    end
    
    describe '#to_i' do
      it 'is the value rounded to the nearest int' do
        subject.to_i.should == value.round
      end
    end
    
    describe '#==' do
      it 'is true if the values are equal' do
        for value in [-10, 0, 5, 100]
          Value.new( value ).should == Value.new( value.to_f )
        end
      end
      it 'is false if the values are not equal' do
        Value.new( 0 ).should_not == Value.new( 0.001 )
        Value.new( -1 ).should_not == Value.new( 1 )        
      end
    end
    
    describe '#<=>' do
      it "is the receiver's value <=> the argument's value" do
        for s1 in subjects
          for s2 in subjects
            ( s1 <=> s2 ).should == ( s1.value <=> s2.value )
          end
        end
      end
    end 
  
    describe '#+' do
      it 'produces a Value with the value of the sum' do
        ( subject + 3 ).should == Value.new( subject.value + 3 )
      end    
    end

    describe '#-' do
      it 'produces a Value with the value of the difference' do
        ( subject + 3 ).should == Value.new( subject.value + 3 )
      end    
    end
    
    describe '#*' do
      it 'produces a Value with the value of the product' do
        ( subject * 3 ).should == Value.new( subject.value * 3 )
      end      
    end

    describe '#/' do
      it 'produces a Value with the value of the product' do
        ( subject * 3 ).should == Value.new( subject.value * 3 )
      end      
    end
  
  end
  
end
