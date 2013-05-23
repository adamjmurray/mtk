require 'spec_helper'

describe MTK::Sequencers::EventBuilder do

  EVENT_BUILDER = MTK::Sequencers::EventBuilder

  let(:pitch) { EVENT_BUILDER::DEFAULT_PITCH }
  let(:intensity) { EVENT_BUILDER::DEFAULT_INTENSITY }
  let(:duration)  { EVENT_BUILDER::DEFAULT_DURATION }

  def notes(*pitches)
    pitches.map{|pitch| Note(pitch, intensity, duration) }
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
      event_builder.next.should == [Note(pitch, intensity, 5.25)]
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

    it "defaults to intensity 'o' when no intensities are given" do
      event_builder = EVENT_BUILDER.new [Patterns.PitchSequence(C4, D4, E4), Patterns.DurationCycle(2)]
      event_builder.next.should == [Note(C4, o, 2)]
      event_builder.next.should == [Note(D4, o, 2)]
      event_builder.next.should == [Note(E4, o, 2)]
    end

    it "defaults to duration 1 when no durations are given" do
      event_builder =  EVENT_BUILDER.new [Patterns.PitchSequence(C4, D4, E4), Patterns.IntensityCycle(p,o)]
      event_builder.next.should == [Note(C4, p, 1)]
      event_builder.next.should == [Note(D4, o, 1)]
      event_builder.next.should == [Note(E4, p, 1)]
    end

    it "builds notes from pitch class sets, selecting the nearest pitch classes to the previous/default pitch" do
      pitch_class_sequence = MTK::Patterns::Sequence.new([PitchClassSet(C,G),PitchClassSet(B,Eb),PitchClassSet(D,C)])
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
      event_builder = EVENT_BUILDER.new [Patterns.PitchCycle(C4, D4, E4), Patterns.IntensityCycle(p, o), Patterns.DurationCycle(1,2,3,4)]
      event_builder.next.should == [Note(C4, p, 1)]
      event_builder.next.should == [Note(D4, o, 2)]
      event_builder.next.should == [Note(E4, p, 3)]
      event_builder.next.should == [Note(C4, o, 4)]
      event_builder.next.should == [Note(D4, p, 1)]
      event_builder.next.should == [Note(E4, o, 2)]
    end

    it "returns nil (for a rest) when it encounters a nil value" do
      event_builder = EVENT_BUILDER.new [Patterns.PitchCycle(C4, D4, E4, F4, nil), Patterns.IntensityCycle(mp, mf, o, nil), Patterns.DurationCycle(1, 2, nil)]
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
      event_builder = EVENT_BUILDER.new [Patterns.Cycle( mp, mf, o )], :default_pitch => G3
      event_builder.next.should == [Note(G3,mp,1)]
      event_builder.next.should == [Note(G3,mf,1)]
      event_builder.next.should == [Note(G3,o,1)]
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
