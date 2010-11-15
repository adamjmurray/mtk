require 'spec_helper'
module Kreet
  
  describe PitchClass do
  
    subject { PitchClass.new('C',0) }
  
    describe '#name' do      
      it "is the name of the pitch class" do
        subject.name.should == 'C'
      end
    end

    describe '#value' do      
      it "is the value of the pitch class" do
        subject.value.should == 0
      end
    end
 
    describe '#==' do
      it "checks for equality by comparing the name and value" do
        subject.should == PitchClass.new('C',0)
        subject.should_not == PitchClass.new('C',1)
        subject.should_not == PitchClass.new('D',0)
        subject.should_not == PitchClass.new('D',1)
      end
    end
    
    describe '#to_s' do
      it "is the name as a string" do
        subject.to_s.should == subject.name.to_s
      end
    end
    
    describe '#to_i' do
      it "is value.to_i" do
        subject.to_i.should == subject.value.to_i
      end
    end

  end  
end
