require 'spec_helper'

describe MTK::Pattern::NoteSequence do

  def note(pitch, intensity=mf, duration=1)
    Note.new pitch,intensity,duration
  end

  def chord(pitches, intensity=mf, duration=1)
    Chord.new pitches,intensity,duration
  end

  describe "#new" do
    it "allows default pitch to be specified" do
      sequence = Pattern::NoteSequence.new [], [p], [1], :pitch => Gb4
      sequence.next.should == Note.new(Gb4, p, 1)
    end
    it "allows default intensity to be specified" do
      sequence = Pattern::NoteSequence.new [C4], [], [1], :intensity => ppp
      sequence.next.should == Note.new(C4, ppp, 1)
    end
    it "allows default duration to be specified" do
      sequence = Pattern::NoteSequence.new [C4], [mf], [], :duration => 12
      sequence.next.should == Note.new(C4, mf, 12)
    end
  end

  describe "#next" do
    it "iterates through the pitch, intensity, and duration list in parallel to emit Notes" do
      sequence = Pattern::NoteSequence.new [C4, D4, E4], [p, f], [1,2,3,4]
      sequence.next.should == Note.new(C4, p, 1)
      sequence.next.should == Note.new(D4, f, 2)
      sequence.next.should == Note.new(E4, p, 3)
      sequence.next.should == Note.new(C4, f, 4)
      sequence.next.should == Note.new(D4, p, 1)
      sequence.next.should == Note.new(E4, f, 2)
    end

    it "defaults to Pitch 'C4' when no pitches are given" do
      sequence = Pattern::NoteSequence.new [], [p,f], [1,2,3]
      sequence.next.should == Note.new(C4, p, 1)
      sequence.next.should == Note.new(C4, f, 2)
      sequence.next.should == Note.new(C4, p, 3)
    end

    it "defaults to intensity 'mf' when no intensities are given" do
      sequence = Pattern::NoteSequence.new [C4, D4, E4], nil, [2]
      sequence.next.should == Note.new(C4, mf, 2)
      sequence.next.should == Note.new(D4, mf, 2)
      sequence.next.should == Note.new(E4, mf, 2)
    end

    it "defaults to duration 1 when no durations are given" do
      sequence = Pattern::NoteSequence.new [C4, D4, E4], [p, f]
      sequence.next.should == Note.new(C4, p, 1)
      sequence.next.should == Note.new(D4, f, 1)
      sequence.next.should == Note.new(E4, p, 1)
    end

    it "uses the previous pitch/intensity/duration when it encounters a nil value" do
      sequence = Pattern::NoteSequence.new [C4, D4, E4, F4, nil], [mp, mf, f, nil], [1, 2, nil]
      sequence.next.should == Note.new(C4, mp, 1)
      sequence.next.should == Note.new(D4, mf, 2)
      sequence.next.should == Note.new(E4, f, 2)
      sequence.next.should == Note.new(F4, f, 1)
      sequence.next.should == Note.new(F4, mp, 2)
      sequence.next.should == Note.new(C4, mf, 2)
    end

    it "adds Numeric intervals in the pitch list to the previous pitch" do
      sequence = Pattern::NoteSequence.new [C4, 1, 2, 3]
      sequence.next.should == note(C4)
      sequence.next.should == note(C4+1)
      sequence.next.should == note(C4+1+2)
      sequence.next.should == note(C4+1+2+3)
      sequence.next.should == note(C4)
    end

    it "goes to the nearest Pitch for any PitchClasses in the pitch list" do
      sequence = Pattern::NoteSequence.new [C4, F, C, G, C]
      sequence.next.should == note(C4)
      sequence.next.should == note(F4)
      sequence.next.should == note(C4)
      sequence.next.should == note(G3)
      sequence.next.should == note(C4)
    end

    it "does not endlessly ascend or descend when alternating between two pitch classes a tritone apart" do
      sequence = Pattern::NoteSequence.new [C4, Gb, C, Gb, C]
      sequence.next.should == note(C4)
      sequence.next.should == note(Gb4)
      sequence.next.should == note(C4)
      sequence.next.should == note(Gb4)
      sequence.next.should == note(C4)
    end

    it "sequences Chords for pitch list items that are PitchSets" do
      sequence = Pattern::NoteSequence.new [PitchSet.new([C4, E4, G4]), C4, PitchSet.new([D4, F4, A4])]
      sequence.next.should == chord([C4, E4, G4])
      sequence.next.should == note(C4)
      sequence.next.should == chord([D4, F4, A4])
    end

    it "adds numeric intervals to PitchSets" do
      sequence = Pattern::NoteSequence.new [PitchSet.new([C4, E4, G4]), 2]
      sequence.next.should == chord([C4, E4, G4])
      sequence.next.should == chord([D4, Gb4, A4])
    end

    it "goes to the nearest Pitch relative to the lowest note in the PitchSet for any PitchClasses in the pitch list" do
      sequence = Pattern::NoteSequence.new [PitchSet.new([C4, E4, G4]), F, D, Bb]
      sequence.next.should == chord([C4, E4, G4])
      sequence.next.should == chord([F4, A4, C5])
      sequence.next.should == chord([D4, Gb4, A4])
      sequence.next.should == chord([Bb3, D4, F4])
    end
  end

  describe "#reset" do
    it "resets the sequence to the beginning" do
      sequence = Pattern::NoteSequence.new [C4, D4, E4], [p, f], [1,2,3,4]
      sequence.next.should == Note.new(C4, p, 1)
      sequence.next.should == Note.new(D4, f, 2)
      sequence.reset
      sequence.next.should == Note.new(C4, p, 1)
      sequence.next.should == Note.new(D4, f, 2)
    end
  end

end
