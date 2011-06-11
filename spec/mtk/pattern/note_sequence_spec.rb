require 'spec_helper'

describe MTK::Pattern::NoteSequence do

  let(:notes) { [Note.new(C4,mf,1), Note.new(D4,mf,1), Note.new(E4,mf,1)] }
  let(:note_sequence) { Pattern::NoteSequence.new(notes) }

  describe "#elements" do
    it "is the array the sequence was constructed with" do
      note_sequence.elements.should == notes
    end
  end

  describe "#notes" do
    it "behaves like #elements" do
      note_sequence.notes.should == note_sequence.elements
    end
  end

  describe ".from_pitches" do
    it "creates a note sequence from a list of pitches with a default intensity of mf and default duration of 1" do
      Pattern::NoteSequence.from_pitches([C4,D4,E4]).should == notes
    end
  end

end
