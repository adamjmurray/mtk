require 'spec_helper'

describe MTK::PitchClass do

  let(:enharmonic_spellings_grouped_by_value) {
    # not sure how to test this without re-coding these names here
    [
      %w( B#  C  Dbb ),
      %w( B## C# Db  ),
      %w( C## D  Ebb ),
      %w( D#  Eb Fbb ),
      %w( D## E  Fb  ),
      %w( E#  F  Gbb ),
      %w( E## F# Gb  ),
      %w( F## G  Abb ),
      %w( G#     Ab  ),
      %w( G## A  Bbb ),
      %w( A#  Bb Cbb ),
      %w( A## B  Cb  )
    ]
  }
  let(:enharmonic_spellings) { enharmonic_spellings_grouped_by_value.flatten }

  
  describe 'NAMES' do
    it "is the 12 note names in western chromatic scale" do
      PitchClass::NAMES.should =~ %w( C Db D Eb E F Gb G Ab A Bb B )
    end

    it "is immutable" do
      lambda{ PitchClass::NAMES << 'H' }.should raise_error
    end
  end

  
  describe 'VALID_NAMES_BY_VALUE' do
    it 'contains enharmonic spellings of NAMES' do
      PitchClass::VALID_NAMES_BY_VALUE.should =~ enharmonic_spellings_grouped_by_value
    end

    it 'organized such that the index of each equivalent spelling matches the index in NAMES' do
      PitchClass::NAMES.each.with_index do |name,index|
        PitchClass::VALID_NAMES_BY_VALUE[index].should include(name)
      end
    end

    it 'is immutable' do
      lambda{ PitchClass::VALID_NAMES_BY_VALUE << 'H' }.should raise_error
    end
  end

  
  describe 'VALID_NAMES' do
    it 'is all enharmonic spellings of NAMES including sharps, flats, double-sharps, and double-flats' do
      PitchClass::VALID_NAMES.should =~ enharmonic_spellings.flatten
    end

    it 'is immutable' do
      lambda{ PitchClass::VALID_NAMES << 'H' }.should raise_error
    end
  end

  
  describe 'PITCH_CLASSES' do
    it 'is the 12 pitch classes in the chromatic scale, indexed by value' do
      for pc in PitchClass::PITCH_CLASSES
        pc.should == PitchClass::PITCH_CLASSES[pc.value]
      end
    end

    it 'is immutable' do
      lambda{ PitchClass::PITCH_CLASSES << C }.should raise_error
    end
  end

  
  describe '.new' do
    it "is private" do
      lambda{ PitchClass.new('C',0) }.should raise_error
    end
  end

  
  describe '.[]' do
    context "the argument is a valid name" do
      it "returns a PitchClass" do
        enharmonic_spellings.each { |name| PitchClass[name].should be_a PitchClass }
      end
      it "returns an object with that name" do
        enharmonic_spellings.each { |name| PitchClass[name].name.should == name }
      end
      it "ignores case" do
        for name in enharmonic_spellings
          PitchClass[name.upcase].name.should == name
          PitchClass[name.downcase].name.should == name
        end
      end
    end
    context "the argument is not a valid name" do
      it "returns nil, if the name doesn't exist" do
        PitchClass['z'].should be_nil
      end
    end
  end

  
  describe '.from_s' do
    it "acts like .[]" do
      for name in ['C', 'bbb', 'z']
        PitchClass.from_s(name).should == PitchClass[name]
      end
    end
  end


  describe '.from_name' do
    it "acts like .[]" do
      for name in ['C', 'bbb', 'z']
        PitchClass.from_name(name).should == PitchClass[name]
      end
    end
  end


  describe '.from_i' do
    it "returns the PitchClass with that value" do
      PitchClass.from_i(2).should == D
    end

    it "returns the PitchClass with that value mod 12" do
      PitchClass.from_i(14).should == D
      PitchClass.from_i(-8).should == E
    end
  end


  describe '.from_value' do
    it 'acts like .from_i' do
      (0..11).each{|v| PitchClass.from_value(v).should == PitchClass.from_i(v) }
    end
  end

  describe '#name' do
    it "is the name of the pitch class" do
      C.name.should == 'C'
    end
  end


  describe '#value' do
    it "is the value of the pitch class" do
      PitchClass::NAMES.each.with_index do |name,value|
        PitchClass[name].value.should == value
      end
    end
  end


  describe '#to_i' do
    it "is the integer value of the pitch class" do
      PitchClass::NAMES.each.with_index do |name,value|
        PitchClass[name].to_i.should == value
        PitchClass[name].to_i.should be_an Integer
      end
    end
  end


  describe '#to_f' do
    it "is the floating point value of the pitch class" do
      PitchClass::NAMES.each.with_index do |name,value|
        PitchClass[name].to_f.should == value
        PitchClass[name].to_f.should be_a Float
      end
    end
  end


  describe '#to_s' do
    it "returns the name" do
      C.to_s.should == C.name
      for name in enharmonic_spellings
        PitchClass.from_s(name).to_s.should == name
      end
    end
  end


  describe '#==' do
    it "checks for equality" do
      C.should == C
      C.should_not == D
    end
    it "treats enharmonic names as equal" do
      C.should == PitchClass('B#')
      C.should == PitchClass('Dbb')
    end
  end


  describe "#<=>" do
    it "compares the underlying int value" do
      (C <=> D).should < 0
      (B <=> C).should > 0
    end
  end


  describe '#+' do
    it "adds an integer argument to the pitch class's value" do
      (C + 4).should == E
    end

    it "'wraps around' the range 0-11" do
      (D + 10).should == C
    end

    it "adds a floating point argument to the pitch class's value, and rounds to the nearest pitch class" do
      (C + 0.49).should == C
      (C + 0.50).should == Db
    end
  end


  describe "#transpose" do
    it "behaves like #+" do
      C.transpose(2).should == C + 2
    end
  end


  describe '#-' do
    it "subtracts an integer argument from the pitch class's value" do
      (E - 2).should == D
    end

    it "'wraps around' the range 0-11" do
      (C - 8).should == E
    end

    it "subtracts a floating point argument from the pitch class's value, and rounds to the nearest pitch class'" do
      (E - 0.50).should == E
      (E - 0.51).should == Eb
    end
  end


  describe "#invert" do
    it 'inverts the pitch class around the given center pitch class' do
      E.invert(D).should == C
    end

    it 'wraps around octaves as needed (always returns a valid pitch class)' do
      E.invert(B).should == Gb
    end

    it "returns the pitch class when the argument is the same pitch class" do
      E.invert(E).should == E
    end

    it 'can invert pitch classes around the halfway point between 2 pitch classes' do
      C.invert(0.5).should == Db
    end
  end


  describe "#distance_to" do
    it "is the distance in semitones between 2 PitchClass objects" do
      C.distance_to(D).should == 2
    end

    it "is the shortest distance (accounts from octave 'wrap around')" do
      B.distance_to(C).should == 1
    end

    it "is a negative distance in semitones when the cloest given PitchClass is at a higher Pitch" do
      D.distance_to(C).should == -2
      C.distance_to(B).should == -1
    end

    it "is (positive) 6 for tritone distances, when this PitchClass is C-F" do
      for pc in [C,Db,D,Eb,E,F]
        pc.distance_to(pc+TT).should == 6
      end
    end

    it "is -6 for tritone distances, when this PitchClass is Gb-B" do
      for pc in [Gb,G,Ab,A,Bb,B]
        pc.distance_to(pc+TT).should == -6
      end
    end
  end

end  

describe MTK do

  describe '#PitchClass' do
    it "acts like from_s if the argument is a String" do
      PitchClass('D').should == PitchClass.from_s('D')
    end

    it "acts like from_s if the argument is a Symbol" do
      PitchClass(:D).should == PitchClass.from_s('D')
    end

    it "acts like from_i if the argument is a Numeric" do
      PitchClass(3).should == PitchClass.from_i(3)
    end

    it "returns the argument if it's already a PitchClass" do
      PitchClass(C).should be_equal C
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchClass({:not => :compatible}) }.should raise_error
    end
  end

end