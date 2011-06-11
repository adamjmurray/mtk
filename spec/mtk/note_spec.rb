require 'spec_helper'

describe MTK::Note do

  let(:pitch) { C4 }
  let(:intensity) { mf }
  let(:duration) { 2.5 }
  let(:note) { Note.new(pitch, intensity, duration) }

  describe "#pitch" do
    it "is the pitch used to create the Note" do
      note.pitch.should == pitch
    end

    it "is a read-only attribute" do
      lambda{ note.pitch = D4 }.should raise_error
    end
  end

  describe "from_hash" do
    it "constructs a Note using a hash" do
      Note.from_hash({ :pitch => C4, :intensity => intensity, :duration => duration }).should == note
    end
  end

  describe 'from_midi' do
    it "constructs a Note using a MIDI pitch and velocity" do
      Note.from_midi(C4.to_i, mf*127, 2.5).should == note
    end
  end

  describe "to_hash" do
    it "is a hash containing all the attributes of the Note" do
      note.to_hash.should == { :pitch => pitch, :intensity => intensity, :duration => duration }
    end
  end

  describe '#transpose' do
    it 'adds the given interval to the @pitch' do
      (note.transpose 2.semitones).should == Note.new(D4, intensity, duration)
    end
    it 'does not affect the immutability of the Note' do
      (note.transpose 2.semitones).should_not == note
    end
  end

  describe "#invert" do
    context 'higher center pitch' do
      it 'inverts the pitch around the given center pitch' do
        note.invert(Pitch 66).should == Note.new(Pitch(72), intensity, duration)
      end
    end

    context 'lower center pitch' do
      it 'inverts the pitch around the given center pitch' do
        note.invert(Pitch 54).should == Note.new(Pitch(48), intensity, duration)
      end
    end

    it "returns the an equal note when given it's pitch as an argument" do
      note.invert(note.pitch).should == note
    end
  end

  describe "#==" do
    it "is true when the pitches, intensities, and durations are equal" do
      note.should == Note.new(pitch, intensity, duration)
    end

    it "is false when the pitches are not equal" do
      note.should_not == Note.new(pitch + 1, intensity, duration)
    end

    it "is false when the intensities are not equal" do
      note.should_not == Note.new(pitch, intensity * 0.5, duration)
    end

    it "is false when the durations are not equal" do
      note.should_not == Note.new(pitch, intensity, duration * 2)
    end
  end

end

describe MTK do

  describe '#Note' do

    it "acts like new for multiple arguments" do
      Note(C4,mf,1).should == Note.new(C4,mf,1)
    end

    it "acts like new for an Array of arguments by unpacking (splatting) them" do
      Note([C4,mf,1]).should == Note.new(C4,mf,1)
    end

    it "returns the argument if it's already a Note" do
      note = Note.new(C4,mf,1)
      Note(note).should be_equal note
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Note({:not => :compatible}) }.should raise_error
    end

  end

end

