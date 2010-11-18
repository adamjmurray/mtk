require 'spec_helper'

  describe Kreet::Pitch do

    let(:c) { PitchClass[:C] }
    let(:g) { PitchClass[:G] }
    let(:middle_c) { Pitch[c, 4] }
    let(:lowest)   { Pitch[c,-1] }
    let(:highest)  { Pitch[g, 9] }   
    let(:subjects) { [middle_c, lowest, highest] }   

    describe '#pitch_class' do
      it "is the pitch class of the pitch" do
        middle_c.pitch_class.should == c
      end
    end

    describe '#octave' do
      it "is the octave of the pitch" do
        middle_c.octave.should == 4
      end
    end

    describe '.from_i' do
      it( "converts 60 to middle C" ) { Pitch.from_i(60).should == middle_c }
      it( "converts 0 to C at octave -1" ) { Pitch.from_i(0).should == lowest }
      it( "converts 127 to G at octave 9" ) { Pitch.from_i(127).should == highest }      
    end
    
    describe '.from_s' do
      it( "converts 'C4' to middle c")  { Pitch.from_s('C4' ).should == middle_c }
      it( "converts 'c4' to middle c")  { Pitch.from_s('c4' ).should == middle_c }
      it( "converts 'B#4' to middle c") { Pitch.from_s('B#4').should == middle_c }
    end

    describe '.[]' do
      it "acts like from_s if the argument is a string" do
        Pitch['D6'].should == Pitch.from_s('D6')        
      end
      it "acts like from_i if the argument is a number" do
        Pitch[3].should == Pitch.from_i(3)
      end
    end

    describe '#to_i' do
      it( "is 60 for middle C" ) { middle_c.to_i.should == 60 }
      it( "is 0 for the C at octave -1" ) { lowest.to_i.should == 0 }
      it( "is 127 for the G at octave 9" ) { highest.to_i.should == 127 }
    end

    describe '#==' do
      it "compares the pitch_class and octave for equality" do
        middle_c.should == Pitch[c,4]
        middle_c.should_not == Pitch[c,3]
        middle_c.should_not == Pitch[g,4]
        middle_c.should_not == Pitch[g,3]
        highest.should == Pitch[g,9]               
      end
    end
    
    describe '#to_s' do
      it "should be the pitch class name and the octave" do
        for pitch in subjects
          pitch.to_s.should == pitch.pitch_class.name + pitch.octave.to_s
        end
      end
    end
    
    describe '#+' do
      it 'adds the integer value of the argument and #to_i' do
        (middle_c + 2).should == Pitch.from_i( 62 )
      end
    end

    describe '#-' do
      it 'subtracts the integer value of the argument from #to_i' do
        (middle_c - 2).should == Pitch.from_i( 58 )
      end
    end
    
  end
