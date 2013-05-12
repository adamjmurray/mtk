require 'spec_helper'
require 'mtk/lang/grammar'

describe MTK::Lang::Grammar do

  def chain *args
    Patterns.Chain *args
  end

  def seq *args
    Patterns.Sequence *args
  end


  def parse(*args)
    MTK::Lang::Grammar.parse(*args)
  end

  describe ".parse" do
    context "default (root rule) behavior" do

    end


    context 'bare_sequencer rule (no curly braces)' do
      it "can parse a sequence of pitch classes" do
        sequencer = parse('C D E F G', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C, D, E, F, G)]
      end

      it "can parse a sequence of pitches" do
        sequencer = parse('C4 D4 E4 F4 G3', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C4, D4, E4, F4, G3)]
      end

      it "can parse a sequence of pitch classes + pitches" do
        sequencer = parse('C4 D E3 F G5', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C4, D, E3, F, G5)]
      end

      it "can parse pitchclass:duration chains" do
        sequencer = parse('C:q D:q E:i F:i G:h', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(chain(C,q), chain(D,q), chain(E,i), chain(F,i), chain(G,h))]
      end

      it "can parse a mix of chained and unchained pitches, pitch classes, durations, and intensities" do
        sequencer = parse('C:q:mp D4:ff A i:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(i,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end
    end


    context 'sequencer rule' do
      it "can parse a sequence of pitch classes" do
        sequencer = parse('{C D E F G}', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C, D, E, F, G)]
      end

      it "can parse a sequence of pitches" do
        sequencer = parse('{ C4 D4 E4 F4 G3}', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C4, D4, E4, F4, G3)]
      end

      it "can parse a sequence of pitch classes + pitches" do
        sequencer = parse('{C4 D E3 F G5 }', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C4, D, E3, F, G5)]
      end

      it "can parse pitchclass:duration chains" do
        sequencer = parse('{  C:q D:q E:i F:i G:h }', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(chain(C,q), chain(D,q), chain(E,i), chain(F,i), chain(G,h))]
      end

      it "can parse a mix of chained and unchained pitches, pitch classes, durations, and intensities" do
        sequencer = parse('{ C:q:mp D4:ff A i:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp   }', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(i,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end
    end


    context "timeline rule" do
      it "should parse a very simple Timeline" do
        parse("{0 => C}", :timeline).should == Timeline.from_hash({0 => Patterns.Chain(C)})
      end

      it "should parse a Timeline with one entry" do
        parse("
          {
            0 => C4:mp:q
          }
        ", :timeline).should == Timeline.from_hash({0 => seq(Patterns.Chain(C4,mp,q))})
      end

      it "should parse a Timeline with multiple entries" do
        parse("
          {
            0 => C4:mp:q
            1 => D4:o:h
          }
        ", :timeline).should == Timeline.from_hash({0 => seq(Patterns.Chain(C4,mp,q)), 1 => seq(Patterns.Chain(D4,o,h))})
      end

      it "should parse a Timeline containing a chord" do
        parse("
          {
            0 => [C4 E4 G4]:fff:w
          }
        ", :timeline).should == Timeline.from_hash({0 => seq(Patterns.Chain(Chord(C4,E4,G4),fff,w))})
      end
    end


    context 'timepoint rule' do
      it 'should evalute a number followed by "=>" as the numberical value' do
        parse('42 => ', :timepoint).should == 42
      end
    end


    context "pattern rule" do
      it 'parses bare sequences' do
        parse("C4 D4 E4", :pattern).should == seq(C4, D4, E4)
      end

      it 'parses sequences' do
        parse("(C4 D4 E4)", :pattern).should == seq(C4, D4, E4)
      end

      it 'parses chains and wraps them in a Sequence' do
        # The wrapping behavior isn't completely desirable,
        # but I'm having trouble making the grammar do exactly what I want in all scenarios, so this is a compromise
        parse("C4:q:ff", :pattern).should == seq(Patterns.Chain(C4, q, ff))
      end
    end


    context 'bare_sequence rule (no parentheses)' do
      it "should parse pitch sequences" do
        parse("C4 D4 E4", :bare_sequence).should == seq(C4, D4, E4)
      end

      it "should parse pitch sequences with chords" do
        parse("C4 [D4 E4]", :bare_sequence).should == seq( C4, Chord(D4,E4) )
      end

      it "should parse pitch sequences with pitch classes" do
        parse("C4 D E4", :bare_sequence).should == seq( C4, D, E4 )
      end

      it "should parse pitch sequences with intervals" do
        parse("C4 m2", :bare_sequence).should == seq( C4, m2 )
      end

      it "parses intensity sequences" do
        parse("ppp mf mp ff", :bare_sequence).should == seq(ppp, mf, mp, ff)
      end

      it "parses duration sequences" do
        parse("q i q. ht", :bare_sequence).should == seq(q, i, q*Rational(1.5), h*Rational(2,3))
      end
    end


    context "sequence rule" do
      it "should parse pitch sequences" do
        parse("(C4 D4 E4)", :sequence).should == seq(C4, D4, E4)
      end

      it "should parse pitch sequences with chords" do
        parse("( C4 [D4 E4])", :sequence).should == seq( C4, Chord(D4,E4) )
      end

      it "should parse pitch sequences with pitch classes" do
        parse("(C4 D E4 )", :sequence).should == seq( C4, D, E4 )
      end

      it "should parse pitch sequences with intervals" do
        parse("( C4 m2  )", :sequence).should == seq( C4, m2 )
      end

      it "parses intensity sequences" do
        parse("(   ppp mf mp ff )", :sequence).should == seq(ppp, mf, mp, ff)
      end

      it "parses duration sequences" do
        parse("(q i q. ht)", :sequence).should == seq(q, i, q*Rational(1.5), h*Rational(2,3))
      end
    end


    context "chain rule" do
      it "parses a basic chain of note properties" do
        parse("G4:h.:ff", :chain).should == Patterns.Chain(G4,h+q,ff)
      end
    end


    context "sequenceable rule" do
      it "should parse a pitch" do
        parse("C4", :sequenceable).should == C4
      end

      it "should parse a chord" do
        parse("[C4 D4]", :sequenceable).should == Chord(C4,D4)
      end

      it "should parse a pitch class" do
        parse("C", :sequenceable).should == C
      end

      it "should parse intervals" do
        parse("m2", :sequenceable).should == m2
      end

      it "should parse durations" do
        parse("h", :sequenceable).should == h
      end

      it "should parse intensities" do
        parse("ff", :sequenceable).should == ff
      end
    end


    context 'chord rule' do
      it "should parse chords" do
        parse("[C4 E4 G4]", :chord).should == Chord(C4,E4,G4)
      end
    end


    context 'pitch rule' do
      it "should parse pitches" do
        for pitch_class_name in PitchClass::VALID_NAMES
          pc = PitchClass[pitch_class_name]
          for octave in -1..9
            parse("#{pitch_class_name}#{octave}", :pitch).should == Pitch[pc,octave]
          end
        end
      end
    end


    context 'pitch_class rule' do
      it "should parse pitch classes" do
        for pitch_class_name in PitchClass::VALID_NAMES
          parse(pitch_class_name, :pitch_class).should == PitchClass[pitch_class_name]
        end
      end
    end


    context 'interval rule' do
      it "should parse intervals" do
        for interval_name in Interval::ALL_NAMES
          parse(interval_name, :interval).should == Interval(interval_name)
        end
      end
    end


    context 'intensity rule' do
      it "should parse intensities" do
        for intensity_name in Intensity::NAMES
          parse(intensity_name, :intensity).should == Intensity(intensity_name)
        end
      end

      it "should parse intensities with + and - modifiers" do
        for intensity_name in Intensity::NAMES
          name = "#{intensity_name}+"
          parse(name, :intensity).should == Intensity(name)
          name = "#{intensity_name}-"
          parse(name, :intensity).should == Intensity(name)
        end
      end
    end


    context 'duration rule' do
      it "should parse durations" do
        for duration in Durations::DURATION_NAMES
          parse(duration, :duration).should == Duration(duration)
        end
      end

      it "should parse durations with . and t modifiers" do
        for duration in Durations::DURATION_NAMES
          name = "#{duration}."
          parse(name, :duration).should == Duration(name)
          name = "#{duration}t"
          parse(name, :duration).should == Duration(name)
          name = "#{duration}..t.t"
          parse(name, :duration).should == Duration(name)
        end
      end
    end


    context 'number rule' do
      it "should parse ints as numbers" do
        parse("123", :number).should == 123
      end

      it "should parse floats as numbers" do
        parse("1.23", :number).should == 1.23
      end
    end

    context 'float rule' do
      it "should parse floats" do
        parse("1.23", :float).should == 1.23
      end

      it "should parse negative floats" do
        parse("-1.23", :float).should == -1.23
      end
    end


    context 'int rule' do
      it "should parse ints" do
        parse("123", :int).should == 123
      end

      it "should parse negative ints" do
        parse("-123", :int).should == -123
      end

      it "should parse negative ints" do
        parse("-123", :int).should == -123
      end
    end


    context 'space rule' do
      it "should give nil as the value for whitespace" do
        parse(" \t\n", :space).should == nil
      end
    end
  end
end