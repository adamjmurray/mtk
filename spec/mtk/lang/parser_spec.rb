require 'spec_helper'

describe MTK::Lang::Parser do

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

  def for_each *args
    Patterns.ForEach *args
  end

  def var(*args)
    ::MTK::Lang::Variable.new(*args)
  end

  def for_each_var(name)
    var(Lang::Variable::FOR_EACH, name, name.length-1)
  end

  def arp_elem_index_var(value)
    var(Lang::Variable::ARPEGGIO_ELEMENT, :index, value)
  end


  def parse(*args)
    MTK::Lang::Parser.parse(*args)
  end


  describe ".parse" do
    it "can parse a single pitch class and play it" do
      sequencer = MTK::Lang::Parser.parse('C')
      timeline = sequencer.to_timeline
      timeline.should ==  MTK::Events::Timeline.from_h({0 => MTK.Note(C4)})
    end

    context "default (root rule) behavior" do
      it "parses a bare_sequencer" do
        sequencer = parse('C:q:mp D4:ff A e:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp')
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(e,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end

      it "parses a sequencer" do
        sequencer = parse('( C:q:mp D4:ff A e:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp  )')
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(e,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end

      it "parses a timeline" do
        parse("
          {
            0 => C4:mp:q
            1 => D4:f:h
          }
        ").should ==  MTK::Events::Timeline.from_h({0 => chain(C4,mp,q), 1 => chain(D4,f,h)})
      end

      it "parses a chain of sequences" do
        sequencer = parse("(C D E F G):(mp mf ff):(q h w)")
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [ chain( seq(C,D,E,F,G), seq(mp,mf,ff), seq(q,h,w) ) ]
      end

      it "parses a chain of choices" do
        sequencer = parse("<e|s>:<C|D|E>")
        sequencer.patterns.should == [ chain( choice(e,s), choice(C,D,E) ) ]
      end

      it "parses a chain of choices" do
        sequencer = parse("(<e|s>:<C|D|E>)&8")
        sequencer.patterns.should == [ seq( chain( choice(e,s), choice(C,D,E) ), min_elements:8, max_elements:8 ) ]
      end

      it "parses the repetition of a basic note property" do
        sequencer = parse("C*4")
        sequencer.patterns.should == [ seq(C, max_cycles:4) ]
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
        sequencer = parse('C:q D:q E:e F:e G:h', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(chain(C,q), chain(D,q), chain(E,e), chain(F,e), chain(G,h))]
      end

      it "parses a mix of chained and unchained pitches, pitch classes, durations, and intensities" do
        sequencer = parse('C:q:mp D4:ff A e:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp', :bare_sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(e,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
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
        sequencer = parse('{  C:q D:q E:e F:e G:h }', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq(chain(C,q), chain(D,q), chain(E,e), chain(F,e), chain(G,h))]
      end

      it "parses a mix of chained and unchained pitches, pitch classes, durations, and intensities" do
        sequencer = parse('{ C:q:mp D4:ff A e:p Eb:pp Bb7 F2:h. F#4:mf:s q ppp   }', :sequencer)
        sequencer.should be_a Sequencers::Sequencer
        sequencer.patterns.should == [seq( chain(C,q,mp), chain(D4,ff), A, chain(e,p), chain(Eb,pp), Bb7, chain(F2,h+q), chain(Gb4,mf,s), q, ppp )]
      end
    end


    context "timeline rule" do
      it "parses a very simple Timeline" do
        parse("{0 => C}", :timeline).should ==  MTK::Events::Timeline.from_h({0 => seq(C)})
      end

      it "parses a Timeline with one entry" do
        parse("
          {
            0 => C4:mp:q
          }
        ", :timeline).should ==  MTK::Events::Timeline.from_h({0 => chain(C4,mp,q)})
      end

      it "parses a Timeline with multiple entries" do
        parse("
          {
            0 => C4:mp:q
            1 => D4:f:h
          }
        ", :timeline).should ==  MTK::Events::Timeline.from_h({0 => chain(C4,mp,q), 1 => chain(D4,f,h)})
      end
    end


    context 'timepoint rule' do
      it 'should evaluate a number followed by "=>" as the numerical value' do
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
        pattern.should == chain( cycle(C,D,E,F, max_cycles:3), seq(q,h,w, min_elements:2, max_elements:2))
        pattern.next
        pattern.next
        lambda{ pattern.next }.should raise_error StopIteration
      end

      it "parses chains of sequencers with modifiers" do
        pattern = parse('(C D E F G):(q h w)&3', :pattern)
        pattern.should == chain( seq(C,D,E,F,G), seq(q,h,w, min_elements:3, max_elements:3))
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
        parse("q e q. ht", :bare_sequence).should == seq(q, e, q*Rational(1.5), h*Rational(2,3))
      end

      it "parses an arpeggio and a pitch" do
        parse("$[C4 D4] C4", :bare_sequence).should == seq(
          Lang::Variable.new(Lang::Variable::ARPEGGIO, '$[C4 D4]', MTK.PitchGroup(C4,D4)), C4
        )
      end

      it "parses arpeggio elements" do
        parse("$0 $1", :bare_sequence).should == seq(arp_elem_index_var(0), arp_elem_index_var(1))
      end

      it "parses an arpeggio and arpeggio indexes" do
        parse("$[C4 D4] $0 $1 $2", :bare_sequence).should == seq(
          Lang::Variable.new(Lang::Variable::ARPEGGIO,'$[C4 D4]',MTK.PitchGroup(C4,D4)),
          arp_elem_index_var(0), arp_elem_index_var(1), arp_elem_index_var(2)
        )
      end
    end


    context "sequence rule" do
      it "parses pitch sequences" do
        parse("(C4 D4 E4)", :sequence).should == seq(C4, D4, E4)
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
        parse("(q e q. ht)", :sequence).should == seq(q, e, q*Rational(1.5), h*Rational(2,3))
      end

      it "parses sequences with a max_cycles modifier" do
        sequence = parse("(C D)*2", :sequence)
        sequence.should == Patterns.Cycle(C,D, max_cycles: 2)
      end

      it "parses sequences with a min+max_elements modifier" do
        sequence = parse("(C D E)&2", :sequence)
        sequence.should == Patterns.Cycle(C,D,E, min_elements: 2, max_elements: 2)
      end
    end


    context "for_each rule" do
      it "parses a for each pattern with 2 subpatterns" do
        for_each = parse('(C D)@(E F)', :for_each)
        for_each.should == Patterns.ForEach(seq(C,D),seq(E,F))
      end

      it "parses a for each pattern with 3 subpatterns" do
        for_each = parse('(C D)@(E F)@(G A B)', :for_each)
        for_each.should == Patterns.ForEach(seq(C,D),seq(E,F),seq(G,A,B))
      end

      it "parses a for each pattern with '$@' variables" do
        for_each = parse('(C D)@(E F)@($@ $@@)', :for_each)
        for_each.should == Patterns.ForEach(
          seq(C,D),
          seq(E,F),
          seq(var(Lang::Variable::FOR_EACH,'$@',1),var(Lang::Variable::FOR_EACH,'$@@',2)))
      end
    end


    context "chain rule" do
      it "parses a basic chain of note properties" do
        parse("G4:h.:ff", :chain).should == Patterns.Chain(G4,h+q,ff)
      end

      it "parses a chain of for each patterns" do
        parse('(C D)@(E F):(G A)@(B C)', :chain).should == chain( for_each(seq(C,D),seq(E,F)), for_each(seq(G,A),seq(B,C)) )
      end

      it "parses chains of elements with max_cycles" do
        parse('C*3:mp*4:q*5', :chain).should == chain( seq(C,max_cycles:3), seq(mp,max_cycles:4), seq(q,max_cycles:5))
      end

      it "parses chained arpeggio element" do
        parse("$0:$1", :chain).should == chain(arp_elem_index_var(0), arp_elem_index_var(1))
      end
    end


    context "chainable rule" do
      it "parses a pitch" do
        parse("C4", :chainable).should == C4
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

      it "parses rests" do
        parse("-h", :chainable).should == -h
      end

      it "parses intensities" do
        parse("ff", :chainable).should == ff
      end
    end

    context 'element rule' do
      it "parses the repetition of a basic note property as a sequence with a max_cycles option" do
        sequence = parse("C*4", :element)
        sequence.should be_a MTK::Patterns::Sequence
        sequence.elements.should == [ C ]
        sequence.max_cycles.should == 4
      end
    end


    context 'variable rule' do
      it 'parses an arpeggio' do
        var = parse("$[C4 D4]", :variable)
        var.should be_a MTK::Lang::Variable
        var.arpeggio?.should be_true
      end

      it 'parses an arpeggio_element' do
        var = parse("$1", :variable)
        var.should be_a MTK::Lang::Variable
        var.arpeggio_element?.should be_true
      end

      it "parses the '$@' for_each variable" do
        parse('$@', :variable).should == for_each_var('$@')
      end

      it "parses the '$@', '$@@', etc for_each variables" do
        parse('$@', :variable).should == for_each_var('$@')
        parse('$@@', :variable).should == for_each_var('$@@')
        parse('$@@@', :variable).should == for_each_var('$@@@')
      end
    end


    context 'arpeggio rule' do
      it "parses an arpeggio" do
        arpeggio = parse("$[C4 D4 E4 F4 G4 A4 B4]", :arpeggio)
        arpeggio.should be_a MTK::Lang::Variable
        arpeggio.arpeggio?.should be_true
        arpeggio.value.should == MTK.PitchGroup(C4, D4, E4, F4, G4, A4, B4)
      end
    end


    context 'arpeggio_element rule' do
      it "parses $N patterns as a Variable with arpeggio_element? true" do
        variable = parse("$1", :arpeggio_element)
        variable.should be_a MTK::Lang::Variable
        variable.name.should be :index
        variable.arpeggio_element?.should be_true
      end

      it "parses $1 with value 1" do
        variable = parse("$1", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :index
        variable.value.should == 1
      end

      it "parses $1234567890 with value 1234567890" do # unrealistic step number, just checking the parsing
        variable = parse("$1234567890", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :index
        variable.value.should == 1234567890
      end

      it "parses $0" do
        variable = parse("$0", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :index
        variable.value.should == 0
      end

      it "parses negative indexes" do
        variable = parse("$-1", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :index
        variable.value.should == -1
      end

      it "parses indexes with a $% prefix as a variable named :modulo_index" do
        for syntax in ['$%1', '$%123456789', '$%0', '$%-1']
          variable = parse(syntax, :arpeggio_element)
          variable.arpeggio_element?.should be_true
          variable.name.should be :modulo_index
          variable.value.should == syntax[2..-1].to_i
        end
      end

      it "parses positive increments" do
        variable = parse("$+", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :increment
        variable.value.should == 1
      end

      it "parses multi-positive increments" do
        variable = parse("$+++", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :increment
        variable.value.should == 3
      end

      it "parses decrement increments" do
        variable = parse("$-", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :increment
        variable.value.should == -1
      end

      it "parses multi-negative increments" do
        variable = parse("$---", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :increment
        variable.value.should == -3
      end

      it "parses increments with a $% prefix as a variable named :modulo_increment" do
        for syntax in ['$%+', '$%+++', '$%-', '$%----']
          variable = parse(syntax, :arpeggio_element)
          variable.arpeggio_element?.should be_true
          variable.name.should be :modulo_increment
          value = syntax.size-2 # don't count '$%'
          value = -value if syntax =~ /-/
          variable.value.should == value
        end
      end

      it "parses random arpeggio elements" do
        variable = parse("$?", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :random
      end

      it "parses 'all' arpeggio elements" do
        variable = parse("$!", :arpeggio_element)
        variable.arpeggio_element?.should be_true
        variable.name.should be :all
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

      it "doesn't allow a sharp and flat to be applied to the same diatonic pitch class" do
        for pitch_class_name in %w(A B C D E F G)
          lambda{ parse(pitch_class_name + '#b', :pitch_class) }.should raise_error
          lambda{ parse(pitch_class_name + 'b#', :pitch_class) }.should raise_error
        end
      end
    end


    context 'diatonic_pitch_class rule' do
      it "parses upper case diatonic pitch classes" do
        for diatonic_pitch_class_name in %w(A B C D E F G)
          parse(diatonic_pitch_class_name, :diatonic_pitch_class).should == PitchClass[diatonic_pitch_class_name]
        end
      end
    end


    context 'accidental rule' do
      it "parses a single flat 'b'" do
        lambda{ parse('b', :accidental) }.should_not raise_error
      end

      it "parses a double flat 'bb'" do
        lambda{ parse('bb', :accidental) }.should_not raise_error
      end

      it "parses a single sharp '#'" do
        lambda{ parse('#', :accidental) }.should_not raise_error
      end

      it "parses a double sharp '##'" do
        lambda{ parse('##', :accidental) }.should_not raise_error
      end

      it "doesn't parse trip flats or sharps" do
        lambda{ parse('bbb', :accidental) }.should raise_error
        lambda{ parse('###', :accidental) }.should raise_error
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

      it "parses durations with - modifier (it parses rests)" do
        for duration in Durations::DURATION_NAMES
          parse("-#{duration}", :duration).should == -1 * Duration(duration)
        end
      end

      it "parses durations with integer multipliers" do
        Durations::DURATION_NAMES.each_with_index do |duration, index|
          multiplier = index+5
          parse("#{multiplier}#{duration}", :duration).should == multiplier * Duration(duration)
        end
      end

      it "parses durations with float multipliers" do
        Durations::DURATION_NAMES.each_with_index do |duration, index|
          multiplier = (index+1)*1.123
          parse("#{multiplier}#{duration}", :duration).should == multiplier * Duration(duration)
        end
      end

      it "parses durations with float multipliers" do
        Durations::DURATION_NAMES.each_with_index do |duration, index|
          multiplier = Rational(index+1, index+2)
          parse("#{multiplier}#{duration}", :duration).should == multiplier * Duration(duration)
        end
      end

    end


    context 'number rule' do
      it "parses floats as numbers" do
        parse("1.23", :number).should == 1.23
      end

      it "parses rationals as numbers" do
        parse("12/34", :number).should == Rational(12,34)
      end

      it "parses ints as numbers" do
        parse("123", :number).should == 123
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

    context 'rational rule' do
      it 'parses rationals' do
        parse('12/13', :rational).should == Rational(12,13)
      end

      it 'parses negative rationals' do
        parse('-12/13', :rational).should == -Rational(12,13)
      end
    end


    context 'int rule' do
      it "parses ints" do
        parse("123", :int).should == 123
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