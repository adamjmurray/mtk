require 'spec_helper'

describe MTK::PitchClass do

  let(:names) {
    [
        ['B#', 'C', 'Dbb'],
        ['B##', 'C#', 'Db'],
        ['C##', 'D', 'Ebb'],
        ['D#', 'Eb', 'Fbb'],
        ['D##', 'E', 'Fb'],
        ['E#', 'F', 'Gbb'],
        ['E##', 'F#', 'Gb'],
        ['F##', 'G', 'Abb'],
        ['G#', 'Ab'],
        ['G##', 'A', 'Bbb'],
        ['A#', 'Bb', 'Cbb'],
        ['A##', 'B', 'Cb']
    ].flatten
  }

  describe 'NAMES' do
    it "is the 12 note names in western chromatic scale" do
      PitchClass::NAMES =~ ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B']
    end
  end

  describe 'VALID_NAMES' do
    it "is all enharmonic spellings of NAMES including sharps, flats, double-sharps, and double-flats" do
      PitchClass::VALID_NAMES =~ names
    end
  end

  describe '.new' do
    it "is private" do
      lambda{ PitchClass.new('C',0) }.should raise_error
    end
  end

  describe '.from_s' do
    context "the argument is a valid name" do
      it "returns a PitchClass" do
        names.each { |name| PitchClass.from_s(name).should be_a PitchClass }
      end
      it "returns an object with that name" do
        names.each { |name| PitchClass.from_s(name).name.should == name }
      end
      it "ignores case" do
        for name in names
          PitchClass.from_s(name.upcase).name.should == name
          PitchClass.from_s(name.downcase).name.should == name
        end
      end
    end
    context "the argument is not a valid name" do
      it "returns nil, if the name doesn't exist" do
        PitchClass.from_s('z').should be_nil
      end
    end
  end

  describe '.from_name' do
    it "acts like from_s" do
      for name in ['C', 'bbb', 'z']
        PitchClass.from_name(name).should == PitchClass.from_s(name)
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

  describe '#name' do
    it "is the name of the pitch class" do
      C.name.should == 'C'
    end
  end

  describe '#to_i' do
    it "is the integer value of the pitch class" do
      C.to_i.should == 0
      D.to_i.should == 2
      E.to_i.should == 4
    end
  end

  describe '#to_s' do
    it "returns the name" do
      C.to_s.should == C.name
      for name in names
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
    it "adds the integer value of the argument and #to_i" do
      (C + 4).should == E
    end

    it "'wraps around' the range 0-11" do
      (D + 10).should == C
    end
  end

  describe "#transpose" do
    it "behaves like #+" do
      C.transpose(2.semitones).should == C + 2
    end
  end

  describe '#-' do
    it "subtracts the integer value of the argument from #to_i" do
      (E - 2).should == D
    end

    it "'wraps around' the range 0-11" do
      (C - 8).should == E
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

    it "acts like from_i if the argument is a Numberic" do
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