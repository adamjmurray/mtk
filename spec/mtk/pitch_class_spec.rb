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

  describe '.[]' do
    it "acts like from_name if the argument is a string" do
      PitchClass['D'].should == PitchClass.from_name('D')
    end
    it "acts like from_i if the argument is a number" do
      PitchClass[3].should == PitchClass.from_i(3)
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
      C.should == PitchClass['B#']
      C.should == PitchClass['Dbb']
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

  describe '#-' do
    it "subtracts the integer value of the argument from #to_i" do
      (E - 2).should == D
    end
    it "'wraps around' the range 0-11" do
      (C - 8).should == E
    end
  end

end  
