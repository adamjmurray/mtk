require 'spec_helper'

describe MTK::Sequencers::EventBuilder do

  EVENT_BUILDER = MTK::Sequencers::EventBuilder

  let(:pitch) { EVENT_BUILDER::DEFAULT_PITCH }
  let(:intensity) { EVENT_BUILDER::DEFAULT_INTENSITY }
  let(:duration)  { EVENT_BUILDER::DEFAULT_DURATION }

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

    it "defaults to a starting point of C4 (middle C)" do
      event_builder = EVENT_BUILDER.new [Patterns.Sequence(C4)]
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

      it "interprets scale random variables against the scale and scale index that occurred most recently" do
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

      it "interprets arpeggio all variables against the arpeggio and arpeggio index that occurred most recently" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          arpeggio(C4,D4,E4,F4,G4,A4,B4),
          arpeggio(Db5,Eb5),
          arp_elem_all_var, arp_elem_all_var
        )])
        event_builder.next.should == [Note(Db5,q),Note(Eb5,q)]
        event_builder.next.should == [Note(Db5,q),Note(Eb5,q)]
      end

      it "interprets arpeggio random variables against the arpeggio and arpeggio index that occurred most recently" do
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
    end


    context "interval group behaviors" do
      it "interprets chords against a C scale by default" do
        event_builder = EVENT_BUILDER.new([Patterns.Sequence(
          MTK::Groups::IntervalGroup.new(MTK::Groups::IntervalGroup::MINOR_TRIAD, 0),
          MTK::Groups::IntervalGroup.new(MTK::Groups::IntervalGroup::MINOR_TRIAD, 3),
          MTK::Groups::IntervalGroup.new(MTK::Groups::IntervalGroup::MAJOR_TRIAD, 4)
        )])

        event_builder.next.should == [Note(C4,q),Note(Eb4,q),Note(G4,q)]
        event_builder.next.should == [Note(F4,q),Note(Ab4,q),Note(C5,q)]
        event_builder.next.should == [Note(G4,q),Note(B4,q),Note(D5,q)]
      end
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
