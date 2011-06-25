require 'spec_helper'

describe MTK::PitchClasses do
  let(:cases) {
    [
        [PitchClasses::C,  'C',   0],
        [PitchClasses::Db, 'Db',  1],
        [PitchClasses::D,  'D',   2],
        [PitchClasses::Eb, 'Eb',  3],
        [PitchClasses::E,  'E',   4],
        [PitchClasses::F,  'F',   5],
        [PitchClasses::Gb, 'Gb',  6],
        [PitchClasses::G,  'G',   7],
        [PitchClasses::Ab, 'Ab',  8],
        [PitchClasses::A,  'A',   9],
        [PitchClasses::Bb, 'Bb', 10],
        [PitchClasses::B,  'B',  11],
    ]
  }

  it "defines constants for the 12 pitch classes in the twelve-tone octave" do
    cases.length.should == 12
    cases.each do |const, name, int_value|
      const.name.should == name
      const.to_i.should == int_value
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
end
