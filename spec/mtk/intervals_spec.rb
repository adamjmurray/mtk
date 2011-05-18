require 'spec_helper'
module IntervalSpec
  include Intervals
  
  describe MTK::Intervals do
    
    describe 'P1' do
      it 'is 0 semitones' do
        P1.should == 0
      end
    end
  
    describe 'MIN2' do
      it 'is 1 semitone' do
        MIN2.should == 1
      end
    end
  
    describe 'MAJ2' do
      it 'is 2 semitones' do
        MAJ2.should == 2
      end
    end
  
    describe 'MIN3' do
      it 'is 3 semitones' do
        MIN3.should == 3
      end
    end
  
    describe 'MAJ3' do
      it 'is 4 semitones' do
        MAJ3.should == 4
      end
    end
  
    describe 'P4' do
      it 'is 5 semitones' do
        P4.should == 5
      end
    end
  
    describe 'AUG4' do
      it 'is 6 semitones' do
        AUG4.should == 6
      end
    end
  
    describe 'DIM5' do
      it 'is 6 semitones' do
        DIM5.should == 6
      end
    end
  
    describe 'P5' do
      it 'is 7 semitones' do
        P5.should == 7
      end
    end
  
    describe 'MIN6' do
      it 'is 8 semitones' do
        MIN6.should == 8
      end
    end
  
    describe 'MAJ6' do
      it 'is 9 semitones' do
        MAJ6.should == 9
      end
    end
  
    describe 'MIN7' do
      it 'is 10 semitones' do
        MIN7.should == 10
      end
    end
  
    describe 'MAJ7' do
      it 'is 11 semitones' do
        MAJ7.should == 11
      end
    end
  
    describe 'P8' do
      it 'is 12 semitones' do
        P8.should == 12
      end
    end
  
  end

end