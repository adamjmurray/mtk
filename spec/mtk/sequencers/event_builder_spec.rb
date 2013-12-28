require 'spec_helper'

describe MTK::Sequencers::EventBuilder do

  EVENT_BUILDER = MTK::Sequencers::EventBuilder

  let(:pitch) { EVENT_BUILDER::DEFAULT_PITCH }
  let(:intensity) { EVENT_BUILDER::DEFAULT_INTENSITY }
  let(:duration)  { EVENT_BUILDER::DEFAULT_DURATION }

  def event_builder_for_sequence(*args)
    EVENT_BUILDER.new([Patterns.Sequence(*args)])
  end

  def events_for_sequence(*args)
    eb = event_builder_for_sequence(*args)
    events = []
    loop do
      event = eb.next
      event = event.first if event.size == 1
      events << event
    end
    events
  end

  def notes(*pitches)
    pitches.map{|pitch| Note(pitch, intensity, duration) }
  end

  def scale(*elements)
    MTK::Lang::Variable.new(Variable::SCALE, '', MTK.PitchClassGroup(*elements))
  end

  def scale_elem_index_var(index)
    MTK::Lang::Variable.new(Variable::SCALE_ELEMENT, :index, index)
  end

  def scale_elem_inc_var(increment)
    MTK::Lang::Variable.new(Variable::SCALE_ELEMENT, :increment, increment)
  end

  def scale_elem_rand_var
    MTK::Lang::Variable.new(Variable::SCALE_ELEMENT, :random)
  end

  def scale_elem_all_var
    MTK::Lang::Variable.new(Variable::SCALE_ELEMENT, :all)
  end

  def arpeggio(*elements)
    MTK::Lang::Variable.new(Variable::ARPEGGIO, '', MTK.PitchGroup(*elements))
  end

  def arp_elem_index_var(index)
    MTK::Lang::Variable.new(Variable::ARPEGGIO_ELEMENT, :index, index)
  end

  def arp_elem_mod_index_var(index)
    MTK::Lang::Variable.new(Variable::ARPEGGIO_ELEMENT, :modulo_index, index)
  end

  def arp_elem_inc_var(increment)
    MTK::Lang::Variable.new(Variable::ARPEGGIO_ELEMENT, :increment, increment)
  end

  def arp_elem_mod_inc_var(increment)
    MTK::Lang::Variable.new(Variable::ARPEGGIO_ELEMENT, :modulo_increment, increment)
  end

  def arp_elem_all_var
    MTK::Lang::Variable.new(Variable::ARPEGGIO_ELEMENT, :all)
  end

  def arp_elem_rand_var
    MTK::Lang::Variable.new(Variable::ARPEGGIO_ELEMENT, :random)
  end

  def mod_elem(modifier, element)
    MTK::Lang::ModifiedElement.new(modifier, element)
  end

  def octave_mod(offset)
    MTK::Lang::Modifier.new(:octave, offset)
  end


  describe "#new" do
    it "allows default pitch to be specified" do
      event_builder = EVENT_BUILDER.new [Patterns.IntervalCycle(0)], :default_pitch => Gb4
      event_builder.next.should == [Note(Gb4, intensity, duration)]
    end
    it "allows default intensity to be specified" do
      event_builder = EVENT_BUILDER.new [Patterns.IntervalCycle(0)], :default_intensity => ppp
      event_builder.next.should == [Note(pitch, ppp, duration)]
    end
    it "allows default duration to be specified" do
      event_builder = EVENT_BUILDER.new [Patterns.IntervalCycle(0)], :default_duration => 5.25
      event_builder.next.should == [Note(pitch, 5.25, intensity)]
    end
  end

  describe "#next" do
    it "builds a single-note list from a single-pitch pattern argument" do
      event_builder = EVENT_BUILDER.new [Patterns.Cycle(C4)]
      event_builder.next.should == notes(C4)
    end

    it "builds a list of notes from any pitches in the argument" do
      event_builder = EVENT_BUILDER.new [Patterns.Cycle(C4), Patterns.Cycle(D4)]
      event_builder.next.should == notes(C4, D4)
    end

    it "builds a list of notes from pitch sets" do
      event_builder = EVENT_BUILDER.new [ Patterns.Cycle( Chord(C4,D4) ) ]
      event_builder.next.should == notes(C4, D4)
    end

    it "builds notes from pitch classes and a default_pitch, selecting the nearest pitch class to the previous pitch" do
      event_builder = EVENT_BUILDER.new [Patterns.Sequence(C,G,B,Eb,D,C)], :default_pitch => D3
      notes = []
      loop do
        notes << event_builder.next
      end
      notes.flatten.should == notes(C3,G2,B2,Eb3,D3,C3)
    end

    it "returns raises StopIteration when there are no more events" do
      event_builder = EVENT_BUILDER.new [Patterns.Sequence(C)]
      event_builder.next
      ->{ event_builder.next }.should raise_error StopIteration
    end

    it "defaults to a starting point of C4 (middle C)" do
      event_builder = EVENT_BUILDER.new [Patterns.Sequence(C)]
      event_builder.next.should == notes(C4)
    end

    it "defaults to intensity 'f' when no intensities are given" do
      event_builder = EVENT_BUILDER.new [Patterns.PitchSequence(C4, D4, E4), Patterns.DurationCycle(2)]
      event_builder.next.should == [Note(C4, f, 2)]
      event_builder.next.should == [Note(D4, f, 2)]
      event_builder.next.should == [Note(E4, f, 2)]
    end

    it "defaults to duration 1 when no durations are given" do
      event_builder =  EVENT_BUILDER.new [Patterns.PitchSequence(C4, D4, E4), Patterns.IntensityCycle(p,f)]
      event_builder.next.should == [Note(C4, p, 1)]
      event_builder.next.should == [Note(D4, f, 1)]
      event_builder.next.should == [Note(E4, p, 1)]
    end

    it "builds notes from pitch class sets, selecting the first pitches nearest to the default pitch" do
      pitch_class_sequence = MTK::Patterns::Sequence.new([PitchClassSet(C,G)])
      event_builder = EVENT_BUILDER.new [pitch_class_sequence], :default_pitch => D3
      event_builder.next.should == notes(C3,G3)
    end

    it "builds notes from pitch class groups, selecting the nearest pitch classes to the previous/default pitch" do
      pitch_class_sequence = MTK::Patterns::Sequence.new([PitchClassGroup(C,G),PitchClassGroup(B,Eb),PitchClassGroup(D,C)])
      event_builder = EVENT_BUILDER.new [pitch_class_sequence], :default_pitch => D3
      event_builder.next.should == notes(C3,G3)
      event_builder.next.should == notes(B3,Eb3)
      event_builder.next.should == notes(D3,C3)
    end

    it "builds notes from by adding Numeric intervals in :pitch type Patterns to the previous Pitch" do
      event_builder = EVENT_BUILDER.new [ Patterns.Sequence( C4, M3, m3, -P5 ) ]
      nexts = []
      loop { nexts << event_builder.next }
      nexts.should == [notes(C4), notes(E4), notes(G4), notes(C4)]
    end

    it "builds notes from by adding Numeric intervals in :pitch type Patterns to all pitches in the previous Chord" do
      event_builder = EVENT_BUILDER.new [ Patterns.Sequence( Chord(C4,Eb4), M3, m3, -P5) ]
      nexts = []
      loop { nexts << event_builder.next }
      nexts.should == [notes(C4,Eb4), notes(E4,G4), notes(G4,Bb4), notes(C4,Eb4)]
    end

    it "builds notes from intensities" do
      event_builder = EVENT_BUILDER.new [ Patterns.Cycle(C4), Patterns.Sequence(mf, p, fff) ]
      nexts = []
      loop { nexts += event_builder.next }
      nexts.should == [Note(C4, mf, duration), Note(C4, p, duration), Note(C4, fff, duration)]
    end

    it "builds notes from durations" do
      event_builder = EVENT_BUILDER.new [ Patterns.PitchCycle(C4), Patterns.DurationSequence(1,2,3) ]
      nexts = []
      loop { nexts += event_builder.next }
      nexts.should == [Note(C4, intensity, 1), Note(C4, intensity, 2), Note(C4, intensity, 3)]
    end

    it "iterates through the pitch, intensity, and duration list in parallel to emit Notes" do
      event_builder = EVENT_BUILDER.new [Patterns.PitchCycle(C4, D4, E4), Patterns.IntensityCycle(p, f), Patterns.DurationCycle(1,2,3,4)]
      event_builder.next.should == [Note(C4, p, 1)]
      event_builder.next.should == [Note(D4, f, 2)]
      event_builder.next.should == [Note(E4, p, 3)]
      event_builder.next.should == [Note(C4, f, 4)]
      event_builder.next.should == [Note(D4, p, 1)]
      event_builder.next.should == [Note(E4, f, 2)]
    end

    it "returns nil (for a rest) when it encounters a nil value" do
      event_builder = EVENT_BUILDER.new [Patterns.PitchCycle(C4, D4, E4, F4, nil), Patterns.IntensityCycle(mp, mf, f, nil), Patterns.DurationCycle(1, 2, nil)]
      event_builder.next.should == [Note(C4, mp, 1)]
      event_builder.next.should == [Note(D4, mf, 2)]
      event_builder.next.should be_nil
      event_builder.next.should be_nil
      event_builder.next.should be_nil
    end

    it "goes to the nearest Pitch for any PitchClasses in the pitch list" do
      event_builder = EVENT_BUILDER.new [Patterns::Cycle(C4, F, C, G, C)]
      event_builder.next.should == notes(C4)
      event_builder.next.should == notes(F4)
      event_builder.next.should == notes(C4)
      event_builder.next.should == notes(G3)
      event_builder.next.should == notes(C4)
    end

    it "does not endlessly ascend or descend when alternating between two pitch classes a tritone apart" do
      event_builder = EVENT_BUILDER.new [Patterns::Cycle(C4, Gb, C, Gb, C)]
      event_builder.next.should == notes(C4)
      event_builder.next.should == notes(Gb4)
      event_builder.next.should == notes(C4)
      event_builder.next.should == notes(Gb4)
      event_builder.next.should == notes(C4)
    end

    it "handles pitches and chords intermixed" do
      event_builder = EVENT_BUILDER.new [Patterns.Cycle( Chord(C4, E4, G4), C4, Chord(D4, F4, A4) )]
      event_builder.next.should == notes(C4,E4,G4)
      event_builder.next.should == notes(C4)
      event_builder.next.should == notes(D4,F4,A4)
    end

    it "adds numeric intervals to Chord" do
      event_builder = EVENT_BUILDER.new [Patterns::Cycle( Chord(C4, E4, G4), M2 )]
      event_builder.next.should == notes(C4,E4,G4)
      event_builder.next.should == notes(D4,Gb4,A4)
    end

    it "goes to the nearest Pitch relative to the lowest note in the Chord for any PitchClasses in the pitch list" do
      event_builder = EVENT_BUILDER.new [Patterns.Cycle( Chord(C4, E4, G4), F, D, Bb )]
      event_builder.next.should == notes(C4,E4,G4)
      event_builder.next.should == notes(F4)
      event_builder.next.should == notes(D4)
      event_builder.next.should == notes(Bb3)
    end

    it "uses the default_pitch when no pitch pattern is provided" do
      event_builder = EVENT_BUILDER.new [Patterns.Cycle( mp, mf, f )], :default_pitch => G3
      event_builder.next.should == [Note(G3,mp,1)]
      event_builder.next.should == [Note(G3,mf,1)]
      event_builder.next.should == [Note(G3,f,1)]
    end

    it "handles chains of sequences" do
      event_builder = EVENT_BUILDER.new [ Patterns.Chain( Patterns.Sequence(C4,D4,E4), Patterns.Sequence(mp,mf,ff), Patterns.Sequence(q,h,w) ) ]
      event_builder.next.should == [Note(C4,mp,q)]
      event_builder.next.should == [Note(D4,mf,h)]
      event_builder.next.should == [Note(E4,ff,w)]
    end

    it "enforces the max_interval option for rising intervals" do
      event_builder = EVENT_BUILDER.new( [ Patterns.Sequence(C4,P5,P5,P5,P5,P5,P5,P5,P5,P5,P5,P5,P5)], max_interval:12 )
      pitches = []
      13.times{ pitches << event_builder.next[0].pitch }
      pitches.should == [C4,G4,D4,A4,E4,B4,Gb4,Db4,Ab4,Eb4,Bb4,F4,C5]

      event_builder = EVENT_BUILDER.new( [ Patterns.Sequence(C4,P5,P5,P5,P5,P5,P5,P5,P5,P5,P5,P5,P5)], max_interval:11 )
      pitches = []
      13.times{ pitches << event_builder.next[0].pitch }
      pitches.should == [C4,G4,D4,A4,E4,B4,Gb4,Db4,Ab4,Eb4,Bb4,F4,C4]
    end

    it "enforces the max_interval option for falling intervals" do
      event_builder = EVENT_BUILDER.new( [ Patterns.Sequence(C4,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5)], max_interval:12 )
      pitches = []
      13.times{ pitches << event_builder.next[0].pitch }
      pitches.should == [C4,F3,Bb3,Eb3,Ab3,Db3,Gb3,B3,E3,A3,D3,G3,C3]

      event_builder = EVENT_BUILDER.new( [ Patterns.Sequence(C4,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5,-P5)], max_interval:11 )
      pitches = []
      13.times{ pitches << event_builder.next[0].pitch }
      pitches.should == [C4,F3,Bb3,Eb3,Ab3,Db3,Gb3,B3,E3,A3,D3,G3,C4]
    end

    it "adds chained durations together" do
      event_builder = EVENT_BUILDER.new( [Patterns.Chain(h,q,e,s)] )
      event_builder.next[0].duration.should == h+q+e+s
    end

    it "averages chained intensities together" do
      event_builder = EVENT_BUILDER.new( [Patterns.IntensityChain(0.1, 0.2, 0.3, 0.4)] )
      event_builder.next[0].intensity.should == Intensity(0.25)
    end

    it "defaults the intensity to the previous intensity" do
      event_builder = EVENT_BUILDER.new(
        [Patterns.Sequence(Patterns.Chain(C4,ppp,q), Patterns.Chain(D4,e), Patterns.Chain(E4,ff,h), Patterns.Chain(F4,e))]
      )
      notes = []
      4.times{ notes += event_builder.next }
      notes.should == [Note(C4,ppp,q), Note(D4,ppp,e), Note(E4,ff,h), Note(F4,ff,e)]
    end

    it "defaults the duration to the previous duration" do
      event_builder = EVENT_BUILDER.new(
          [Patterns.Sequence(Patterns.Chain(C4,ppp,h), Patterns.Chain(D4,mp), Patterns.Chain(E4,ff,s), Patterns.Chain(F4,mf))]
      )
      notes = []
      4.times{ notes += event_builder.next }
      notes.should == [Note(C4,ppp,h), Note(D4,mp,h), Note(E4,ff,s), Note(F4,mf,s)]
    end

    it "uses the previous pitch class in the chain to determine the octave of the current pitch class" do
      event_builder = EVENT_BUILDER.new([Patterns.Chain(C4,E,G)])
      event_builder.next.should == [Note(C4),Note(E4),Note(G4)]
    end

    it "returns a Rest event when the duration is negative" do
      event_builder = EVENT_BUILDER.new([Patterns.Chain(C4,-q)])
      event_builder.next.should == [Rest(q)]
    end

    it "doesn't uses the absolute value of the previous rest when generating the next event" do
      event_builder = EVENT_BUILDER.new([Patterns.Sequence(Patterns.Chain(C4,q), -q, D4)])
      event_builder.next.should == [Note(C4,q)]
      event_builder.next.should == [Rest(q)]
      event_builder.next.should == [Note(D4,q)]
    end

    it "makes all event chained to a rest be a rest" do
      event_builder = EVENT_BUILDER.new(
        [Patterns.Sequence(Patterns.Chain(C4,q), Patterns.Chain(-q, Patterns.Sequence(D4,E4)))]
      )
      event_builder.next.should == [Note(C4,q)]
      event_builder.next.should == [Rest(q)]
      event_builder.next.should == [Rest(q)]
    end


    context "scale behaviors" do
      it "interprets scale index variables within the C major scale by default" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale_elem_index_var(0), scale_elem_index_var(1), scale_elem_index_var(2), scale_elem_index_var(3),
          scale_elem_index_var(4), scale_elem_index_var(5), scale_elem_index_var(6), scale_elem_index_var(7)
        )])
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(D4,q)]
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(F4,q)]
        event_builder.next.should == [Note(G4,q)]
        event_builder.next.should == [Note(A4,q)]
        event_builder.next.should == [Note(B4,q)]
        event_builder.next.should == [Note(C5,q)]
      end

      it "interprets scale index variables against the scale that occurred most recently" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(C,D,E),
          scale(Db,Eb),
          scale_elem_index_var(0), scale_elem_index_var(1), scale_elem_index_var(2)
        )])
        event_builder.next.should == [Note(Db4,q)]
        event_builder.next.should == [Note(Eb4,q)]
        event_builder.next.should == [Note(Db4,q)]
      end

      it "interprets scale increment variables against the scale and scale index that occurred most recently" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(C,D,E),
          scale(Db,Eb,Gb,Ab,Bb),
          scale_elem_index_var(0), scale_elem_inc_var(1), scale_elem_inc_var(0), scale_elem_inc_var(-3)
        )])
        event_builder.next.should == [Note(Db4,q)]
        event_builder.next.should == [Note(Eb4,q)]
        event_builder.next.should == [Note(Eb4,q)]
        event_builder.next.should == [Note(Ab4,q)]
      end

      it "has a default scale index of 0" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(C,D,E),
          scale(Db,Eb,E,F),
          scale_elem_inc_var(2), scale_elem_inc_var(0), scale_elem_inc_var(-3)
        )])
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(F4,q)]
      end

      it "interprets scale 'random' variables against the scale that occurred most recently" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
            scale(Db,Eb),
            scale(Lang::PitchClasses::PITCH_CLASSES),
            scale_elem_rand_var, scale_elem_rand_var, scale_elem_rand_var, scale_elem_rand_var, scale_elem_rand_var, scale_elem_rand_var
        )])
        first_event = event_builder.next
        first_event.length.should == 1

        first = first_event[0].pitch
        second = event_builder.next[0].pitch
        third = event_builder.next[0].pitch
        fourth = event_builder.next[0].pitch
        fifth = event_builder.next[0].pitch
        sixth = event_builder.next[0].pitch
        (first==second && first==second && first==third && first==fourth && first==fifth && first==sixth ).should be_false
        # slight chance this will fail, just run again
      end

      it "sets the scale index to the scale 'random' variable's index for any successive scale increment variables" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(Lang::PitchClasses::PITCH_CLASSES),
          scale_elem_rand_var, scale_elem_inc_var(0),
          scale_elem_rand_var, scale_elem_inc_var(1),
          scale_elem_rand_var, scale_elem_inc_var(-1)
        )])
        prev_pitch = event_builder.next[0].pitch
        # now an increment of 0 should give the same pitch
        event_builder.next[0].pitch.should == prev_pitch
        prev_pitch = event_builder.next[0].pitch
        # and an increment of 1:
        event_builder.next[0].pitch.should == prev_pitch+1
        prev_pitch = event_builder.next[0].pitch
        # and  an increment of -1:
        event_builder.next[0].pitch.should == prev_pitch-1
      end

      it "interprets scale 'all' variables against the current scale, with each pitch closest to the previous pitch in the scale" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(Db,Eb),
          scale(C,D,F,G,A),
          scale_elem_all_var, scale_elem_all_var
        )])
        event_builder.next.should == [Note(C4),Note(D4),Note(F4),Note(G4),Note(A4)]
      end

      it "treats the scale 'all' variable's scale root as the next event's previous pitch" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(C,D,F,G,A),
          scale_elem_all_var, scale_elem_all_var
        )])
        # In other words, it emits the same event repeatedly
        event_builder.next.should == [Note(C4),Note(D4),Note(F4),Note(G4),Note(A4)]
        event_builder.next.should == [Note(C4),Note(D4),Note(F4),Note(G4),Note(A4)]
      end

      it "does not change the scale index when a scale 'all' variable is evaluated" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(C,D,F,G,A),
          scale_elem_inc_var(1), scale_elem_all_var, scale_elem_inc_var(1)
        )])
        event_builder.next[0].pitch.should == D4
        event_builder.next # the whole scale, previous pitch will be C4
        event_builder.next[0].pitch.should == F4
      end

      it "interprets octave-modified scale indexes" do
        events = events_for_sequence(
          scale(C,D,E),
          E4, scale_elem_index_var( mod_elem(octave_mod(1), 0) ),
          C5, scale_elem_index_var( mod_elem(octave_mod(-1),2) ),
          E4, scale_elem_index_var( mod_elem(octave_mod(2), 0) ),
          C5, scale_elem_index_var( mod_elem(octave_mod(-3),1) )
        )
        events.should == notes(E4,C5,C5,E4,E4,C6,C5,D2)
      end
    end
    

    context "arpeggio behaviors" do
      it "interprets arpeggio index variables within the middle C major triad arpeggio by default" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arp_elem_index_var(0), arp_elem_index_var(1), arp_elem_index_var(2), arp_elem_index_var(3))]
        )
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(G4,q)]
        event_builder.next.should == [Note(C5,q)]
      end

      it "interprets arpeggio index variables against the arpeggio that occurred most recently" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(Db5,Eb5),
          arpeggio(C4,D4,E4,F4,G4,A4,B4),
          arp_elem_index_var(0), arp_elem_index_var(1), arp_elem_index_var(4), arp_elem_index_var(7)
        )])
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(D4,q)]
        event_builder.next.should == [Note(G4,q)]
        event_builder.next.should == [Note(C5,q)]
      end

      it "'wraps around' (doesn't apply octave offsets) for arpeggio element variables named :modulo_index" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(C4,E4,G4),
          arp_elem_mod_index_var(0), arp_elem_mod_index_var(3), arp_elem_mod_index_var(4), arp_elem_mod_index_var(8),
          arp_elem_mod_index_var(-3), arp_elem_mod_index_var(-2), arp_elem_mod_index_var(-4)
        )])
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(G4,q)]
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(G4,q)]
      end

      it "interprets arpeggio increment variables against the arpeggio and arpeggio index that occurred most recently" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(Db5,Eb5),
          arpeggio(C4,D4,E4,F4,G4,A4,B4),
          arp_elem_index_var(0), arp_elem_inc_var(2), arp_elem_inc_var(0), arp_elem_inc_var(-3)
        )])
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(B3,q)]
      end

      it "has a default arpeggio index of 0" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(Db5,Eb5),
          arpeggio(C4,D4,E4,F4,G4,A4,B4),
          arp_elem_inc_var(2), arp_elem_inc_var(0), arp_elem_inc_var(-3)
        )])
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(B3,q)]
      end

      it "'wraps around' (doesn't apply octave offsets) for arpeggio element variables named :modulo_increment" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(C4,E4,G4),
          arp_elem_mod_inc_var(1), arp_elem_mod_inc_var(1), arp_elem_mod_inc_var(1),
          arp_elem_mod_inc_var(-3), arp_elem_mod_inc_var(-1), arp_elem_mod_inc_var(-2), arp_elem_mod_inc_var(-2)
        )])
        event_builder.next.should == [Note(E4,q)]
        event_builder.next.should == [Note(G4,q)]
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(G4,q)]
        event_builder.next.should == [Note(C4,q)]
        event_builder.next.should == [Note(E4,q)]
      end

      it "interprets arpeggio 'all' variables against the arpeggio and arpeggio index that occurred most recently" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(C4,D4,E4,F4,G4,A4,B4),
          arpeggio(Db5,Eb5),
          arp_elem_all_var, arp_elem_all_var
        )])
        event_builder.next.should == [Note(Db5,q),Note(Eb5,q)]
        event_builder.next.should == [Note(Db5,q),Note(Eb5,q)]
      end

      it "interprets arpeggio 'random' variables against the arpeggio and arpeggio index that occurred most recently" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(Db5,Eb5),
          arpeggio(Lang::Pitches::PITCHES),
          arp_elem_rand_var, arp_elem_rand_var, arp_elem_rand_var, arp_elem_rand_var
        )])
        first_event = event_builder.next
        first_event.length.should == 1

        first = first_event[0].pitch
        second = event_builder.next[0].pitch
        third = event_builder.next[0].pitch
        fourth = event_builder.next[0].pitch
        (first==second && first==second && first==third && first==fourth ).should be_false
        # slight chance this will fail, just run again
      end

      it "sets the arpeggio index to the arpeggio 'random' variable's index for any successive arpeggio increment variables" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          # use a full chromatic scale so 'wrap-around' will just go up/down to next/prev octave
          arpeggio(C4,Db4,D4,Eb4,E4,F4,Gb4,G4,Ab4,A4,Bb4,B4),
          arp_elem_rand_var, arp_elem_inc_var(0),
          arp_elem_rand_var, arp_elem_inc_var(1),
          arp_elem_rand_var, arp_elem_inc_var(-1)
        )])
        prev_pitch = event_builder.next[0].pitch
        # now an increment of 0 should give the same pitch
        event_builder.next[0].pitch.should == prev_pitch
        prev_pitch = event_builder.next[0].pitch
        # and an increment of 1:
        event_builder.next[0].pitch.should == prev_pitch+1
        prev_pitch = event_builder.next[0].pitch
        # and  an increment of -1:
        event_builder.next[0].pitch.should == prev_pitch-1
      end

      it "does not change the arpeggio index when a arpeggio 'all' variable is evaluated" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(C4,D4,F4,G4,A4),
          arp_elem_inc_var(1), arp_elem_all_var, arp_elem_inc_var(1)
        )])
        event_builder.next[0].pitch.should == D4
        event_builder.next # the whole scale, previous pitch will be C4
        event_builder.next[0].pitch.should == F4
      end

      it "interprets relative chord arpeggios with the default C major scale" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          Variable.new(Variable::ARPEGGIO, '', MTK::Groups::RelativeChord.from_s('V')),
          arp_elem_index_var(0),
          arp_elem_index_var(1),
          arp_elem_index_var(2)
        )])
        event_builder.next.should == notes(G3)
        event_builder.next.should == notes(B3)
        event_builder.next.should == notes(D4)
      end

      it "interprets relative chord arpeggios with a specified scale" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(D,E,Gb,G,A,B,Db),
          Variable.new(Variable::ARPEGGIO, '', MTK::Groups::RelativeChord.from_s('V')),
          arp_elem_index_var(0),
          arp_elem_index_var(1),
          arp_elem_index_var(2)
        )])
        event_builder.next.should == notes(A3)
        event_builder.next.should == notes(Db4)
        event_builder.next.should == notes(E4)
      end

      it "interprets relative chord arpeggios in a for each pattern" do
        event_builder = EVENT_BUILDER.new([ MTK::Patterns::ForEach.new([
          Patterns.Sequence(
            Variable.new(Variable::ARPEGGIO, '', MTK::Groups::RelativeChord.from_s('I')),
            Variable.new(Variable::ARPEGGIO, '', MTK::Groups::RelativeChord.from_s('IV')),
            Variable.new(Variable::ARPEGGIO, '', MTK::Groups::RelativeChord.from_s('V')),
            Variable.new(Variable::ARPEGGIO, '', MTK::Groups::RelativeChord.from_s('I'))
          ),
          Patterns.Sequence(
            MTK::Lang::Variable.new(Variable::FOR_EACH_ELEMENT, :index, 0),
            arp_elem_index_var(0),
            arp_elem_index_var(1),
            arp_elem_index_var(2)
          )
        ])])
        notes = []
        12.times{ notes += event_builder.next }
        notes.should == notes(C4,E4,G4,F4,A4,C5,G4,B4,D5,C5,E5,G5)
      end
    end


    context "interval group behaviors" do
      it "interprets chords against a C scale by default" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          MTK::Lang::IntervalGroups::MINOR_TRIAD,
          MTK::Lang::IntervalGroups::MAJOR_TRIAD
        )])

        event_builder.next.should == [Note(C4,q),Note(Eb4,q),Note(G4,q)]
        event_builder.next.should == [Note(C4,q),Note(E4,q),Note(G4,q)]
      end
    end


    context "relative chord behaviors" do
      it "interprets chords against a C scale by default" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          MTK::Lang::RelativeChords::i,
          MTK::Lang::RelativeChords::iv,
          MTK::Lang::RelativeChords::V
        )])
        event_builder.next.should == notes(C4,Eb4,G4)
        event_builder.next.should == notes(F4,Ab4,C5)
        event_builder.next.should == notes(G4,B4,D5)
      end

      it "interprets chords against the given scale" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          scale(D,E,Gb,G,A,B,Db),
          MTK::Lang::RelativeChords::I,
          MTK::Lang::RelativeChords::vi
        )])
        event_builder.next.should == notes(D4,Gb4,A4)
        event_builder.next.should == notes(B3,D4,Gb4)
      end

      it "interprets chords against the given scale, using the octave of the previous pitch" do
        eb = event_builder_for_sequence scale(D,E,Gb,G,A,B,Db), C5, MTK::Lang::RelativeChords::I
        eb.next
        eb.next.should == notes(D5,Gb5,A5)
      end
    end


    context "octave modifier behavior" do
      it "changes the octave of 'previous_pitch' by the Modifer's value to change the octave of the following pitch class" do
        events = events_for_sequence(
          C4, MTK::Lang::Modifier.new(:octave,1), D, E, MTK::Lang::Modifier.new(:octave,-2), F
        )
        events.should == notes(C4, D5, E5, F3)
      end

      it "does not emit any events" do
        eb = event_builder_for_sequence MTK::Lang::Modifier.new(:octave,1)
        ->{ eb.next }.should raise_error StopIteration
      end
    end


    context "force_rest modifier behavior" do
      it "turns non-rest notes into rests" do
        event_builder = EVENT_BUILDER.new([Patterns.Chain(
          C4,
          MTK::Lang::Modifier.new(:force_rest)
        )])
        notes = event_builder.next
        notes.length.should == 1
        note = notes.first
        note.rest?.should be_true
        note.duration.should == -duration
      end

      it "turns keeps rest notes as rests" do
        event_builder = EVENT_BUILDER.new([Patterns.Chain(
          C4,
          MTK::Core::Duration.new(-1),
          MTK::Lang::Modifier.new(:force_rest)
        )])
        notes = event_builder.next
        notes.length.should == 1
        note = notes.first
        note.rest?.should be_true
        note.duration.should == -1
      end
    end


    context "skip modifier behavior" do
      it "skips over the skip modifier and returns the next event" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          C4, MTK::Lang::Modifier.new(:skip), D4
        )])
        event_builder.next.should == [Note(C4)]
        event_builder.next.should == [Note(D4)]
        ->{ event_builder.next }.should raise_error StopIteration
      end

      it "allows for optionally emitting an event when a skip modifier is used within a Choice pattern" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          C4, Patterns.Choice(MTK::Lang::Modifier.new(:skip), D4), E4
        )])
        saw_skip = false
        saw_non_skip = true
        25.times do
          event_builder.rewind
          events = []
          loop{ events += event_builder.next }
          if events == [Note(C4),Note(E4)]
            saw_skip = true
          elsif events == [Note(C4),Note(D4),Note(E4)]
            saw_non_skip = true
          else
            fail "Unexpected event stream: #{events}"
          end
        end
        saw_skip.should be_true
        saw_non_skip.should be_true
        # slight chance of failure, just run again
      end
    end


    context "octave-modified pitch classes" do
      it "causes pitch classes modified with ' to be the closest above the previous pitch" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,1), G)
        )
        events.should == notes(C4,G4) # would normally be C4,G3 without modifier
      end

      it "causes pitch classes modified with , to be the closest below the previous pitch" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,-1), F)
        )
        events.should == notes(C4,F3) # would normally be C4, F4 without modifier
      end

      it "causes pitch classes modified with '' to be 1 octave above the closest above the previous pitch" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,2), G)
        )
        events.should == notes(C4,G5)
      end

      it "causes pitch classes modified with ,, to be 1 octave below the closest below the previous pitch" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,-2), F)
        )
        events.should == notes(C4,F2)
      end

      it "doesn't change the pitch class's nearest pitch behavior unnecessarily (ascending case)" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,1), E)
        )
        events.should == notes(C4,E4)
      end

      it "doesn't change the pitch class's nearest pitch behavior unnecessarily (ascending case)" do
        events = events_for_sequence(
          E4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,-1), C)
        )
        events.should == notes(E4,C4)
      end
    end


    context "octave-modified relative chords" do
      it "causes relative chords modified with ' to be the closest above the previous pitch" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,1), V)
        )
        events.should == [Note(C4), notes(G4,B4,D5)] # would normally be C4,[G3,B3,D4] without modifier
      end

      it "causes relative chords modified with , to be the closest below the previous pitch" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,-1), IV)
        )
        events.should == [Note(C4), notes(F3,A3,C4)] # would normally be C4,[F4,A4,C5] without modifier
      end

      it "causes relative chords modified with '' to be 1 octave above the closest above the previous pitch" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,2), V)
        )
        events.should == [Note(C4), notes(G5,B5,D6)]
      end

      it "causes relative chords modified with ,, to be 1 octave below the closest below the previous pitch" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,-2), IV)
        )
        events.should == [Note(C4), notes(F2,A2,C3)]
      end

      it "doesn't change the relative chords's nearest pitch behavior unnecessarily (ascending case)" do
        events = events_for_sequence(
          C4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,1), iii)
        )
        events.should == [Note(C4), notes(E4,G4,B4)]
      end

      it "doesn't change the relative chords's nearest pitch behavior unnecessarily (ascending case)" do
        events = events_for_sequence(
          E4, MTK::Lang::ModifiedElement.new(MTK::Lang::Modifier.new(:octave,-1), I)
        )
        events.should == [Note(E4), notes(C4,E4,G4)]
      end
    end


    context "octave-modified arpeggios" do
      it "handles octave-modified relative chord arpeggios" do
        events = events_for_sequence(
          Variable.new(Variable::ARPEGGIO, '', MTK::Groups::RelativeChord.from_s('V')),
          arp_elem_index_var(0),
          arp_elem_index_var(1),
          arp_elem_index_var(2),
          Variable.new(Variable::ARPEGGIO, '', MTK::Lang::ModifiedElement.new(
            MTK::Lang::Modifier.new(:octave, -2), # TODO: buggy, I want this to be -1
            MTK::Groups::RelativeChord.from_s('I')
          )),
          arp_elem_index_var(0),
          arp_elem_index_var(1),
          arp_elem_index_var(2),
        )
        events.should == notes(G3,B3,D4,C3,E3,G3)
      end
    end


    context "for_each behaviors" do
      it "uses the pitches from a for each 'all' variable to form multiple notes" do
        event_builder = EVENT_BUILDER.new([ MTK::Patterns::ForEach.new([
          Patterns.Sequence(C4), Patterns.Sequence(D4), Patterns.Sequence(E4),
          Patterns.Sequence( MTK::Lang::Variable.new(Variable::FOR_EACH_ELEMENT, :all) )
        ]) ])
        event_builder.next.should == notes(C4,D4,E4)
      end
    end

    it "removes duplicate pitches" do
      event_builder = EVENT_BUILDER.new([Patterns.Sequence(
        MTK.PitchGroup(C4,C4,C4),
        Patterns.Chain(D4,D4,D4)
      )])
      event_builder.next.should == notes(C4)
      event_builder.next.should == notes(D4)
    end
  end


  describe "#rewind" do
    it "resets the state of the Chain" do
      event_builder = EVENT_BUILDER.new [ Patterns.Sequence(C,P8) ]
      event_builder.next.should == [Note(C4,intensity,duration)]
      event_builder.next.should == [Note(C5,intensity,duration)]
      event_builder.rewind
      event_builder.next.should == [Note(C4,intensity,duration)]
    end
  end

end
