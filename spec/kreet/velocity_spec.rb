require 'spec_helper'
module Kreet

  describe Velocity do
    
    let(:min) { Velocity.new(0.0) }
    let(:mid) { Velocity.new(0.5) }  
    let(:max) { Velocity.new(1.0) }
    subject { mid }
    let(:subjects) { [min, mid, max] }
    
    it 'should have Comparable methods' do
      Velocity.should include Comparable
      min.should      < max
      max.should_not  > max
      min.should     <= min
      min.should     <= max
      max.should_not <= min
      min.should     >= min
      max.should     >= min
      min.should_not >= max
      max.should      > min
      min.should_not  > max
    end
    
    describe '#name' do
      it 'is :velocity' do
        subject.name.should == :velocity
      end
    end
    
    describe '#value' do
      it 'is the value the object was constructed with' do
        min.value.should == 0.0
        mid.value.should == 0.5
        max.value.should == 1.0
      end
    end
    
    describe 'from_i' do
      it 'Maps integer values 0-127 to Velocity objects with the value 0.0-1.0' do
        128.times do |int_value|
          Velocity.from_i( int_value ).should == Velocity.new( int_value/127.0 )
        end
      end
    end
      
    describe '#to_i' do
      it 'Maps the Velocities with the value range 0.0-1.0 to integer values 0-127' do
        min.to_i.should == 0
        mid.to_i.should == 64
        max.to_i.should == 127
      end
    end
    
    describe '#==' do
      it 'is true if the values are equal' do
        for value in [-10, 0, 5, 100]
          Velocity.new( value ).should == Velocity.new( value.to_f )
        end
      end
      it 'is false if the values are not equal' do
        Velocity.new( 0 ).should_not == Velocity.new( 0.001 )
        Velocity.new( -1 ).should_not == Velocity.new( 1 )        
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
  
  end
end
