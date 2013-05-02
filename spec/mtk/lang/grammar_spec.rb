require 'spec_helper'
require 'mtk/lang/grammar'

describe MTK::Lang::Grammar do

  def parse syntax, root
    MTK::Lang::Grammar.parse(syntax, root)
  end

  describe ".parse" do

    context "timeline" do
      it "should parse a Timeline" do
        parse("
          {
            0 => {C4 mp q}
            1 => {D4 o h}
          }
        ", :timeline).should == Timeline.from_hash({0 => Note(C4,mp,q), 1 => Note(D4,o,h)})
      end

      it "should parse a Timeline" do
        parse("
          {
            0 => [{C4 mp q} {D4 o h}]
          }
        ", :timeline).should == Timeline.from_hash({0 => [Note(C4,mp,q), Note(D4,o,h)]})
      end
    end

    it "should parse a list of notes in square brackets as an Array of Notes" do
      parse("[{C4 mp q} {D4 o h}]", :note_list).should == [Note(C4,mp,q), Note(D4,o,h)]
    end

    it "should parse {pitch intensity duration} as a Note" do
      parse("{C4 mp q}", :note).should == Note(C4,mp,q)
    end

    context "pitch_sequence" do
      it "should parse pitch sequences" do
        parse("(C4 D4 E4)", :pitch_sequence).should == Patterns.PitchSequence(C4, D4, E4)
      end

      it "should parse pitch sequences with chords" do
        parse("(C4 [D4 E4])", :pitch_sequence).should == Patterns.PitchSequence( C4, Chord(D4,E4) )
      end

      it "should parse pitch sequences with pitch classes" do
        parse("( C4 D E4 )", :pitch_sequence).should == Patterns.PitchSequence( C4, D, E4 )
      end

      it "should parse pitch sequences with intervals" do
        parse("(C4 m2)", :pitch_sequence).should == Patterns.PitchSequence( C4, m2 )
      end
    end


    it "parses intensity sequences" do
      parse("(ppp mf mp ff)", :intensity_sequence).should == Patterns.IntensitySequence(ppp, mf, mp, ff)
    end

    it "parses duration sequences" do
      parse("(q i q. ht)", :duration_sequence).should == Patterns.DurationSequence(q, i, q*1.5, h*2/3.0)
    end


    context "pitch_like" do
      it "should parse a pitch" do
        parse("C4", :pitch_like).should == C4
      end

      it "should parse a chord" do
        parse("[C4 D4]", :pitch_like).should == Chord(C4,D4)
      end

      it "should parse a pitch class" do
        parse("C", :pitch_like).should == C
      end

      it "should parse intervals" do
        parse("m2", :pitch_like).should == m2
      end
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