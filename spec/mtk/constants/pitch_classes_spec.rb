require 'spec_helper'

describe MTK::Constants::PitchClasses do
  let(:cases) {
    [
        [PitchClass['C'],  'C',   0],
        [PitchClass['Db'], 'Db',  1],
        [PitchClass['D'],  'D',   2],
        [PitchClass['Eb'], 'Eb',  3],
        [PitchClass['E'],  'E',   4],
        [PitchClass['F'],  'F',   5],
        [PitchClass['Gb'], 'Gb',  6],
        [PitchClass['G'],  'G',   7],
        [PitchClass['Ab'], 'Ab',  8],
        [PitchClass['A'],  'A',   9],
        [PitchClass['Bb'], 'Bb', 10],
        [PitchClass['B'],  'B',  11],
    ]
  }

  it "defines constants for the 12 pitch classes in the twelve-tone octave" do
    cases.length.should == 12
    cases.each do |const, name, value|
      const.name.should == name
      const.value.should == value
    end
  end

  describe "PITCH_CLASSES" do
    it "contains the 12 pitch class constants" do
      PitchClasses::PITCH_CLASSES.length.should == 12
      PitchClasses::PITCH_CLASSES.should == cases.map{ |const,_,__| const }
    end

    it "is immutable" do
      lambda{ PitchClasses::PITCH_CLASSES << :something }.should raise_error
    end
  end

  describe "PITCH_CLASS_NAMES" do
    it "contains the names of the 12 pitch class constants" do
      PitchClasses::PITCH_CLASS_NAMES.length.should == 12
      PitchClasses::PITCH_CLASS_NAMES.should == cases.map{ |_,name,__| name }
    end

    it "is immutable" do
      lambda{ PitchClasses::PITCH_CLASS_NAMES << :something }.should raise_error
    end
  end

  describe ".[]" do
    it "acts like PitchClass.[]" do
      for name in PitchClasses::PITCH_CLASS_NAMES
        PitchClasses[name].should == PitchClass[name]
      end
    end

    it "returns nil for arguments it doesn't understand" do
      PitchClasses[:invalid].should be_nil
    end
  end
end
