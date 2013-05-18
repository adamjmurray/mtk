require 'spec_helper'
require 'mtk/lang/grammar'

describe MTK::Lang::Grammar do

  def chain *args
    Patterns.Chain *args
  end

  def seq *args
    Patterns.Sequence *args
  end

  def cycle *args
    Patterns.Cycle *args
  end

  def choice *args
    Patterns.Choice *args
  end

  def foreach *args
    Patterns.ForEach *args
  end

  def var(name)
    ::MTK::Variable.new(name)
  end


  def parse(*args)
    MTK::Lang::Grammar.parse(*args)
  end


  describe ".parse" do
    context "default (root rule) behavior" do
      it "parses a bare_sequencer" do
        sequencer = parse('C:q:mp D4:ff A i:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp')
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(i,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end

      it "parses a sequencer" do
        sequencer = parse('( C:q:mp D4:ff A i:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp  )')
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(i,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end

      it "parses a timeline" do
        parse("
          {
            0 => C4:mp:q
            1 => D4:o:h
          }
        ").should == Timeline.from_hash({0 => chain(C4,mp,q), 1 => chain(D4,o,h)})
      end

      it "parses a chain of sequences" do
        sequencer = parse("(C D E F G):(mp mf ff):(q h w)")
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [ chain( seq(C,D,E,F,G), seq(mp,mf,ff), seq(q,h,w) ) ]
      end
    end


    context 'bare_sequencer rule (no curly braces)' do
      it "parses a sequence of pitch classes" do
        sequencer = parse('C D E F G', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C, D, E, F, G)]
      end

      it "parses a sequence of pitches" do
        sequencer = parse('C4 D4 E4 F4 G3', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C4, D4, E4, F4, G3)]
      end

      it "parses a sequence of pitch classes + pitches" do
        sequencer = parse('C4 D E3 F G5', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C4, D, E3, F, G5)]
      end

      it "parses pitchclass:duration chains" do
        sequencer = parse('C:q D:q E:i F:i G:h', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(chain(C,q), chain(D,q), chain(E,i), chain(F,i), chain(G,h))]
      end

      it "parses a mix of chained and unchained pitches, pitch classes, durations, and intensities" do
        sequencer = parse('C:q:mp D4:ff A i:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(i,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end
    end


    context 'sequencer rule' do
      it "parses a sequence of pitch classes" do
        sequencer = parse('{C D E F G}', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C, D, E, F, G)]
      end

      it "parses a sequence of pitches" do
        sequencer = parse('{ C4 D4 E4 F4 G3}', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C4, D4, E4, F4, G3)]
      end

      it "parses a sequence of pitch classes + pitches" do
        sequencer = parse('{C4 D E3 F G5 }', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(C4, D, E3, F, G5)]
      end

      it "parses pitchclass:duration chains" do
        sequencer = parse('{  C:q D:q E:i F:i G:h }', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(chain(C,q), chain(D,q), chain(E,i), chain(F,i), chain(G,h))]
      end

      it "parses a mix of chained and unchained pitches, pitch classes, durations, and intensities" do
        sequencer = parse('{ C:q:mp D4:ff A i:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp   }', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(i,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end
    end


    context "timeline rule" do
      it "parses a very simple Timeline" do
        parse("{0 => C}", :timeline).should == Timeline.from_hash({0 => seq(C)})
      end

      it "parses a Timeline with one entry" do
        parse("
          {
            0 => C4:mp:q
          }
        ", :timeline).should == Timeline.from_hash({0 => chain(C4,mp,q)})
      end

      it "parses a Timeline with multiple entries" do
        parse("
          {
            0 => C4:mp:q
            1 => D4:o:h
          }
        ", :timeline).should == Timeline.from_hash({0 => chain(C4,mp,q), 1 => chain(D4,o,h)})
      end

      it "parses a Timeline containing a chord" do
        parse("
          {
            0 => [C4 E4 G4]:fff:w
          }
        ", :timeline).should == Timeline.from_hash({0 => chain(Chord(C4,E4,G4),fff,w)})
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
        parse("C4:q:ff", :pattern).should == chain(C4, q, ff)
      end

      it "parses chains of sequencers" do
        parse("(C D E F G):(mp mf ff):(q h w)", :pattern).should == chain( seq(C,D,E,F,G), seq(mp,mf,ff), seq(q,h,w) )
      end

      it "parses chains of sequencers with modifiers" do
        pattern = parse('(C D E F)*3:(q h w)&2', :pattern)
        pattern.should == chain( cycle(C,D,E,F, max_cycles:3), seq(q,h,w, max_elements:2))
        pattern.next
        pattern.next
        lambda{ pattern.next }.should raise_error StopIteration
      end

      it "parses chains of sequencers with modifiers" do
        pattern = parse('(C D E F G):(q h w)&3', :pattern)
        pattern.should == chain( seq(C,D,E,F,G), seq(q,h,w, max_elements:3))
        pattern.next
        pattern.next
        pattern.next
        lambda{ pattern.next }.should raise_error StopIteration
      end

      it "ensures a single element is wrapped in a Pattern" do
        parse("C", :pattern).should be_a ::MTK::Patterns::Pattern
      end

      it "parse 'recursively' nested constructs" do
        parse('C <D|E <F|G F>> | A B:(q h <q|h:mp h:<mf|ff fff>>)', :pattern).should ==
          choice(
            seq(C, choice(D, seq(E, choice(F,seq(G,F))))),
            seq(A, chain(B,seq(q, h, choice(q,seq(chain(h,mp),chain(h,choice(mf,seq(ff,fff))))))))
          )
      end
    end


    context 'bare_choice rule (no parentheses)' do
      it "parses a choice of simple elements" do
        parse('C | D | E', :bare_choice).should == choice(C,D,E)
      end

      it 'parses a choice of sequences (parentheses implied)' do
        parse('C D E | D E F | E F', :bare_choice).should == choice(seq(C,D,E), seq(D,E,F), seq(E,F))
      end

      it 'parses a choice of sequences and simple elements' do
        parse('C D E | G | E F | A', :bare_choice).should == choice(seq(C,D,E), G, seq(E,F), A)
      end

      it "doesn't require spaces around the pipe characters"do
        parse('C D E|G|E F', :bare_choice).should == choice(seq(C,D,E), G, seq(E,F))
      end

      it 'parses choices containing chains' do
        parse('C D:q | G | A:mp|E:fff:h F:s', :bare_choice).should ==
            choice( seq(C,chain(D,q)), G, chain(A,mp), seq(chain(E,fff,h),chain(F,s)) )
      end

      it 'parses choices containing nested choices' do
        parse('C <D|E> | F | G', :bare_choice).should == choice(seq(C,choice(D,E)), F, G)
      end
    end


    context 'choice rule' do
      it "parses a choice of simple elements" do
        parse('<C | D | E>', :bare_choice).should == choice(C,D,E)
      end

      it 'parses a choice of sequences (parentheses implied)' do
        parse('< C D E | D E F | E F>', :bare_choice).should == choice(seq(C,D,E), seq(D,E,F), seq(E,F))
      end

      it 'parses a choice of sequences and simple elements' do
        parse('<C D E | G | E F | A >', :bare_choice).should == choice(seq(C,D,E), G, seq(E,F), A)
      end

      it "doesn't require spaces around the pipe characters"do
        parse('<  C D E|G|E F >', :bare_choice).should == choice(seq(C,D,E), G, seq(E,F))
      end

      it 'parses choices containing chains' do
        parse('<C D:q | G | A:mp|E:fff:h F:s>', :bare_choice).should ==
            choice( seq(C,chain(D,q)), G, chain(A,mp), seq(chain(E,fff,h),chain(F,s)) )
      end

      it 'parses choices containing nested choices' do
        parse('< C <D|E> | F | G >', :bare_choice).should == choice(seq(C,choice(D,E)), F, G)
      end
    end


    context 'bare_sequence rule (no parentheses)' do
      it "parses pitch sequences" do
        parse("C4 D4 E4", :bare_sequence).should == seq(C4, D4, E4)
      end

      it "parses pitch sequences with chords" do
        parse("C4 [D4 E4]", :bare_sequence).should == seq( C4, Chord(D4,E4) )
      end

      it "parses pitch sequences with pitch classes" do
        parse("C4 D E4", :bare_sequence).should == seq( C4, D, E4 )
      end

      it "parses pitch sequences with intervals" do
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
      it "parses pitch sequences" do
        parse("(C4 D4 E4)", :sequence).should == seq(C4, D4, E4)
      end

      it "parses pitch sequences with chords" do
        parse("( C4 [D4 E4])", :sequence).should == seq( C4, Chord(D4,E4) )
      end

      it "parses pitch sequences with pitch classes" do
        parse("(C4 D E4 )", :sequence).should == seq( C4, D, E4 )
      end

      it "parses pitch sequences with intervals" do
        parse("( C4 m2  )", :sequence).should == seq( C4, m2 )
      end

      it "parses intensity sequences" do
        parse("(   ppp mf mp ff )", :sequence).should == seq(ppp, mf, mp, ff)
      end

      it "parses duration sequences" do
        parse("(q i q. ht)", :sequence).should == seq(q, i, q*Rational(1.5), h*Rational(2,3))
      end

      it "parses sequences with a max_cycles modifier" do
        sequence = parse("(C D)*2", :sequence)
        sequence.should == Patterns.Cycle(C,D, max_cycles: 2)
      end

      it "parses sequences with a max_elements modifier" do
        sequence = parse("(C D E)&2", :sequence)
        sequence.should == Patterns.Cycle(C,D,E, max_elements: 2)
      end
    end


    context "foreach rule" do
      it "parses a for each pattern with 2 subpatterns" do
        foreach = parse('(C D)@(E F)', :foreach)
        foreach.should == Patterns.ForEach(seq(C,D),seq(E,F))
      end

      it "parses a for each pattern with 3 subpatterns" do
        foreach = parse('(C D)@(E F)@(G A B)', :foreach)
        foreach.should == Patterns.ForEach(seq(C,D),seq(E,F),seq(G,A,B))
      end

      it "parses a for each pattern with '$' variables" do
        foreach = parse('(C D)@(E F)@($ $$)', :foreach)
        foreach.should == Patterns.ForEach(seq(C,D),seq(E,F),seq(var('$'),var('$$')))
      end
    end


    context "chain rule" do
      it "parses a basic chain of note properties" do
        parse("G4:h.:ff", :chain).should == Patterns.Chain(G4,h+q,ff)
      end

      it "parses a chain of for each patterns" do
        parse('(C D)@(E F):(G A)@(B C)', :chain).should == chain( foreach(seq(C,D),seq(E,F)), foreach(seq(G,A),seq(B,C)) )
      end
    end


    context "chainable rule" do
      it "parses a pitch" do
        parse("C4", :chainable).should == C4
      end

      it "parses a chord" do
        parse("[C4 D4]", :chainable).should == Chord(C4,D4)
      end

      it "parses a pitch class" do
        parse("C", :chainable).should == C
      end

      it "parses intervals" do
        parse("m2", :chainable).should == m2
      end

      it "parses durations" do
        parse("h", :chainable).should == h
      end

      it "parses intensities" do
        parse("ff", :chainable).should == ff
      end
    end


    context 'chord rule' do
      it "parses chords" do
        parse("[C4 E4 G4]", :chord).should == Chord(C4,E4,G4)
      end
    end


    context 'pitch rule' do
      it "parses pitches" do
        for pitch_class_name in PitchClass::VALID_NAMES
          pc = PitchClass[pitch_class_name]
          for octave in -1..9
            parse("#{pitch_class_name}#{octave}", :pitch).should == Pitch[pc,octave]
          end
        end
      end
    end


    context 'pitch_class rule' do
      it "parses pitch classes" do
        for pitch_class_name in PitchClass::VALID_NAMES
          parse(pitch_class_name, :pitch_class).should == PitchClass[pitch_class_name]
        end
      end
    end


    context 'interval rule' do
      it "parses intervals" do
        for interval_name in Interval::ALL_NAMES
          parse(interval_name, :interval).should == Interval(interval_name)
        end
      end
    end


    context 'intensity rule' do
      it "parses intensities" do
        for intensity_name in Intensity::NAMES
          parse(intensity_name, :intensity).should == Intensity(intensity_name)
        end
      end

      it "parses intensities with + and - modifiers" do
        for intensity_name in Intensity::NAMES
          name = "#{intensity_name}+"
          parse(name, :intensity).should == Intensity(name)
          name = "#{intensity_name}-"
          parse(name, :intensity).should == Intensity(name)
        end
      end
    end


    context 'duration rule' do
      it "parses durations" do
        for duration in Durations::DURATION_NAMES
          parse(duration, :duration).should == Duration(duration)
        end
      end

      it "parses durations with . and t modifiers" do
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


    context 'variable rule' do
      it "parses the '$' variable" do
        parse('$', :variable).should == var('$')
      end

      it "parses the '$$', '$$$', etc variables" do
        parse('$$', :variable).should == var('$$')
        parse('$$$', :variable).should == var('$$$')
        parse('$$$$', :variable).should == var('$$$$')
      end
    end


    context 'number rule' do
      it "parses ints as numbers" do
        parse("123", :number).should == 123
      end

      it "parses floats as numbers" do
        parse("1.23", :number).should == 1.23
      end
    end

    context 'float rule' do
      it "parses floats" do
        parse("1.23", :float).should == 1.23
      end

      it "parses negative floats" do
        parse("-1.23", :float).should == -1.23
      end
    end


    context 'int rule' do
      it "parses ints" do
        parse("123", :int).should == 123
      end

      it "parses negative ints" do
        parse("-123", :int).should == -123
      end

      it "parses negative ints" do
        parse("-123", :int).should == -123
      end
    end


    context 'space rule' do
      it "returns nil as the value for whitespace" do
        parse(" \t\n", :space).should == nil
      end
    end
  end
end