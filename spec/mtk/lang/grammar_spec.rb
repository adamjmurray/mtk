require 'spec_helper'
require 'mtk/lang/grammar'

describe MTK::Lang::Grammar do

  def parse syntax, root
    MTK::Lang::Grammar.parse(syntax, root)
  end

  describe ".parse" do

    it "should parse pitch sequences" do
      parse("C4 D4 E4", :pitch_sequence).should == Pattern.PitchSequence(C4, D4, E4)
    end

    it "should parse chords" do
      parse("[C4 E4 G4]", :chord).should == Chord(C4,E4,G4)
    end

    it "should parse pitches" do
      for pitch_class_name in PitchClass::VALID_NAMES
        pc = PitchClass[pitch_class_name]
        for octave in -1..9
          parse("#{pitch_class_name}#{octave}", :pitch).should == Pitch[pc,octave]
        end
      end
    end

    it "should parse pitch classes" do
      for pitch_class_name in PitchClass::VALID_NAMES
        parse(pitch_class_name, :pitch_class).should == PitchClass[pitch_class_name]
      end
    end

    it "should parse intervals" do
      for interval_name in Intervals::INTERVAL_NAMES
        parse(interval_name, :interval).should == Intervals[interval_name]
      end
    end

    it "should parse intensities" do
      for intensity_name in Intensities::INTENSITY_NAMES
        parse(intensity_name, :intensity).should == Intensities[intensity_name]
      end
    end

    it "should parse intensities with + and - modifiers" do
      for intensity_name in Intensities::INTENSITY_NAMES
        name = "#{intensity_name}+"
        parse(name, :intensity).should == Intensities[name]
        name = "#{intensity_name}-"
        parse(name, :intensity).should == Intensities[name]
      end
    end

    it "should parse durations" do
      for duration in Durations::DURATION_NAMES
        parse(duration, :duration).should == Durations[duration]
      end
    end

    it "should parse durations with . and t modifiers" do
      for duration in Durations::DURATION_NAMES
        name = "#{duration}."
        parse(name, :duration).should == Durations[name]
        name = "#{duration}t"
        parse(name, :duration).should == Durations[name]
        name = "#{duration}..t.t"
        parse(name, :duration).should == Durations[name]
      end
    end

    it "should parse ints as numbers" do
      parse("123", :number).should == 123
    end

    it "should parse floats as numbers" do
      parse("1.23", :number).should == 1.23
    end

    it "should parse floats" do
      parse("1.23", :float).should == 1.23
    end

    it "should parse negative floats" do
      parse("-1.23", :float).should == -1.23
    end

    it "should parse ints" do
      parse("123", :int).should == 123
    end

    it "should parse negative ints" do
      parse("-123", :int).should == -123
    end

    it "should parse negative ints" do
      parse("-123", :int).should == -123
    end

    it "should give nil as the value for whitespace" do
      parse(" \t\n", :space).should == nil
    end
  end
end