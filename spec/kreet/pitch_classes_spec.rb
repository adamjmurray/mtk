require 'spec_helper'
module Kreet
  module PitchClasses

    describe PitchClasses do

      let(:cases) {
        [
          [C , 'C' , 0],
          [Db, 'Db', 1],
          [D , 'D',  2],
          [Eb, 'Eb', 3],
          [E , 'E',  4],
          [F , 'F',  5],
          [Gb, 'Gb', 6],
          [G , 'G',  7],
          [Ab, 'Ab', 8],
          [A , 'A',  9],
          [Bb, 'Bb',10],
          [B , 'B', 11],
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
          PITCH_CLASSES.length.should == 12
          PITCH_CLASSES.should == cases.map{|const,_,__| const}
        end
      end

    end

  end
end
