require 'spec_helper'
module Kreet

  describe Velocity do
    
    let(:min) { Velocity.new(0.0) }
    let(:mid) { Velocity.new(0.5) }  
    let(:max) { Velocity.new(1.0) }
    let(:subjects) { [min,mid,max] }
    
    describe '#name' do
      it 'is :velocity' do
        for velocity in subjects
          velocity.name.should == :velocity
        end
      end
    end
    
    describe '#value' do
      it 'is the value the object was constructed with' do
        min.value.should == 0.0
        mid.value.should == 0.5
        max.value.should == 1.0
      end
    end
      
  end
end
