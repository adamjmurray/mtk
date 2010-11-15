require 'spec_helper'
module Kreet
  
  describe PitchClass do
  
    subject { PitchClass }
    let(:c) { PitchClass['C'] }
    let(:d) { PitchClass['D'] }
    let(:e) { PitchClass['E'] }
  
    let(:names) { [
      ['B#',  'C',  'Dbb'],
      ['B##', 'C#', 'Db' ],
      ['C##', 'D',  'Ebb'],
      ['D#',  'Eb', 'Fbb'],
      ['D##', 'E',  'Fb' ],
      ['E#',  'F',  'Gbb'],
      ['E##', 'F#', 'Gb' ],
      ['F##', 'G',  'Abb'],
      ['G#',  'Ab'       ],
      ['G##', 'A',  'Bbb'],
      ['A#',  'Bb', 'Cbb'],
      ['A##', 'B',  'Cb' ]
    ].flatten }
  
    describe 'Names' do
      it "is the 12 note names in 'western' 12-tone octave" do
        PitchClass::NAMES =~ ['C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B']
      end
    end
  
    describe 'from_s' do
      it "returns the PitchClass with that name, if the name exists" do
        subject.from_s('C').should == c
        for name in names
          subject.from_s(name).name.should == name
        end
      end
      it "ignores case" do
        subject.from_s('bbb').should_not be_nil
      end
      it "returns nil, if the name doesn't exist" do
        subject.from_s('z').should be_nil
      end
    end
  
    describe 'from_name' do
      it "acts like from_s" do
        subject.from_name('C').should == subject.from_s('C')
        subject.from_name('bbb').should == subject.from_s('BBB')
        subject.from_name('z').should == subject.from_s('z')
      end
    end
  
    describe 'from_i' do
      it "returns the PitchClass with that value" do
        subject.from_i(2).should == d
      end
      it "returns the PitchClass with that value mod 12" do
        subject.from_i(14).should == d
        subject.from_i(-8).should == e        
      end      
    end
    
    describe '[]' do
      it "acts like from_name if the argument is a string" do
        subject['D'].should == subject.from_name('D')        
      end
      it "acts like from_i if the argument is a number" do
        subject[3].should == subject.from_i(3)
      end
    end
  
    describe '#name' do      
      it "is the name of the pitch class" do
        c.name.should == 'C'
      end
    end

    describe '#to_i' do      
      it "is the integer value of the pitch class" do
        c.to_i.should == 0
        d.to_i.should == 2
        e.to_i.should == 4
      end
    end
    
    describe '#to_s' do
      it "returns the name" do
        c.to_s.should == c.name
      end
    end
        
    describe '#==' do
      it "checks for equality" do
        c.should == c
        c.should_not == d
      end
      it "treats enharmonic names as equal" do
        c.should == PitchClass['B#']
        c.should == PitchClass['Dbb']
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
