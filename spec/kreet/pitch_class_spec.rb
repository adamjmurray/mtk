require 'spec_helper'
module Kreet
  
  describe PitchClass do
  
    subject { PitchClass }
    let(:c) { PitchClass['C'] }
    let(:d) { PitchClass['D'] }
    let(:e) { PitchClass['E'] }
  
    describe 'Names' do
      it "is the 12 note names in 'western' 12-tone octave" do
        PitchClass::Names =~ ['C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B']
      end
    end
  
    describe 'from_name' do
      it "returns the PitchClass with that name, if the name exists" do
        subject.from_name('C').should == c
      end
      it "returns nil, if the name doesn't exist" do
        subject.from_name('z').should be_nil
      end
    end
  
    describe 'from_value' do
      it "returns the PitchClass with that value" do
        subject.from_value(2).should == d
      end
      it "returns the PitchClass with that value mod 12" do
        subject.from_value(14).should == d
        subject.from_value(-8).should == e        
      end
      
    end
    
    describe '[]' do
      it "acts like from_name if the argument is a string" do
        subject['D'].should == subject.from_name('D')        
      end
      it "acts like from_value if the argument is a number" do
        subject[3].should == subject.from_value(3)
      end
    end
  
    describe '#name' do      
      it "is the name of the pitch class" do
        c.name.should == 'C'
      end
    end

    describe '#value' do      
      it "is the value of the pitch class" do
        c.value.should == 0
        d.value.should == 2
        e.value.should == 4
      end
    end
 
    describe '#==' do
      it "checks for equality" do
        c.should == c
        c.should_not == d
      end
    end
    
    describe '#to_s' do
      it "is the name as a string" do
        c.to_s.should == c.name.to_s
      end
    end
    
    describe '#to_i' do
      it "is value.to_i" do
        c.to_i.should == c.value.to_i
      end
    end
    
    describe '#+' do
      it "adds the integer value of the argument and #to_i" do
        (c + 4).should == e
      end
      it "'wraps around' the range 0-11" do
        (d + 10).should == c
      end      
    end

    describe '#-' do
      it "subtracts the integer value of the argument from #to_i" do
        (e - 2).should == d        
      end
      it "'wraps around' the range 0-11" do
        (c - 8).should == e
      end
    end
    
  end  
end
