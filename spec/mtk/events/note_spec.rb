require 'spec_helper'

describe MTK::Events::Note do

  NOTE = Events::Note

  let(:pitch) { C4 }
  let(:intensity) { mf }
  let(:duration) { Duration[2.5] }
  let(:note) { NOTE.new(pitch, intensity, duration) }

  describe "#pitch" do
    it "is the pitch used to create the Note" do
      note.pitch.should == pitch
    end
  end

  describe "#pitch=" do
    it "sets the pitch" do
      note.pitch = D4
      note.pitch.should == D4
    end
  end

  describe "#intensity" do
    it "is the intensity used to create the Event" do
      note.intensity.should == intensity
    end
  end

  describe "#intensity=" do
    it "sets the intensity" do
      note.intensity = fff
      note.intensity.should == fff
    end
  end

  describe "#velocity" do
    it "converts intensities in the range 0.0-1.0 to a MIDI velocity in the range 0-127" do
      NOTE.new(pitch, 0, 0).velocity.should == 0
      NOTE.new(pitch, 1, 0).velocity.should == 127
    end
    it "rounds to the nearest MIDI velocity" do
      NOTE.new(pitch, 0.5, 0).velocity.should == 64 # not be truncated to 63!
    end
  end

  describe "#velocity=" do
    it "sets the velocity" do
      note.velocity = 100
      note.velocity.should == 100
    end
  end

  describe ".from_hash" do
    it "constructs a Note using a hash" do
      NOTE.from_hash({ :pitch => pitch, :intensity => intensity, :duration => duration }).should == note
    end
  end

  describe '.from_midi' do
    it "constructs a Note using a MIDI pitch and velocity" do
      NOTE.from_midi(C4.to_i, mf.value*127, 2.5).should == note
    end
  end

  describe "#to_midi" do
    it "converts the Note to an Array of MIDI values: [pitch, velocity, duration]" do
      note.to_midi.should == [60, (mf.value*127).round, duration.to_f]
    end
  end

  describe "#to_hash" do
    it "is a hash containing all the attributes of the Note" do
      hash = note.to_hash
      # hash includes some extra "baggage" for compatibility with AbstractEvent,
      # so we'll just check the fields we care about:
      hash[:pitch].should == pitch
      hash[:intensity].should == intensity
      hash[:duration].should == duration
    end
  end

  describe '#transpose' do
    it 'adds the given interval to the @pitch' do
      (note.transpose 2).should == NOTE.new(D4, intensity, duration)
    end
  end

  describe "#invert" do
    context 'higher center pitch' do
      it 'inverts the pitch around the given center pitch' do
        note.invert(Pitch 66).should == NOTE.new(Pitch(72), intensity, duration)
      end
    end

    context 'lower center pitch' do
      it 'inverts the pitch around the given center pitch' do
        note.invert(Pitch 54).should == NOTE.new(Pitch(48), intensity, duration)
      end
    end

    it "returns the an equal note when given it's pitch as an argument" do
      note.invert(note.pitch).should == note
    end
  end

  describe "#==" do
    it "is true when the pitches, intensities, and durations are equal" do
      note.should == NOTE.new(pitch, intensity, duration)
    end

    it "is false when the pitches are not equal" do
      note.should_not == NOTE.new(pitch + 1, intensity, duration)
    end

    it "is false when the intensities are not equal" do
      note.should_not == NOTE.new(pitch, intensity * 0.5, duration)
    end

    it "is false when the durations are not equal" do
      note.should_not == NOTE.new(pitch, intensity, duration * 2)
    end
  end

  describe "#to_s" do
    it "includes the #pitch, #intensity to 2 decimal places, and #duration to 2 decimal places" do
      NOTE.new(C4, 1/3.0, 1/3.0).to_s.should == "Note(C4, 0.33, 0.33)"
    end
  end

  describe "#inspect" do
    it "includes the #pitch, #intensity.to_s, and #duration.to_s" do
      NOTE.new(C4, 1/8.0, 1/8.0).inspect.should == "Note(C4, 0.125, 1/8)"
    end
  end

end


describe MTK do

  describe '#Note' do

    it "acts like new for multiple arguments" do
      Note(C4,mf,1).should == NOTE.new(C4,mf,1)
    end

    it "acts like new for an Array of arguments by unpacking (splatting) them" do
      Note([C4,mf,1]).should == NOTE.new(C4,mf,1)
    end

    it "returns the argument if it's already a Note" do
      note = NOTE.new(C4,mf,1)
      Note(note).should be_equal note
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Note({:not => :compatible}) }.should raise_error
    end

  end

end

