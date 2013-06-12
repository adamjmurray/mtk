require 'spec_helper'

describe MTK::Events::Note do

  NOTE = Events::Note

  let(:pitch) { C4 }
  let(:intensity) { mf }
  let(:duration) { Duration[2.5] }
  let(:note) { NOTE.new(pitch, duration, intensity) }

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
      NOTE.new(pitch, 0, 1).velocity.should == 127
    end
    it "rounds to the nearest MIDI velocity" do
      NOTE.new(pitch, 0, 0.5).velocity.should == 64 # not be truncated to 63!
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
      (note.transpose 2).should == NOTE.new(D4, duration, intensity)
    end
  end

  describe "#invert" do
    context 'higher center pitch' do
      it 'inverts the pitch around the given center pitch' do
        note.invert(Pitch 66).should == NOTE.new(Pitch(72), duration, intensity)
      end
    end

    context 'lower center pitch' do
      it 'inverts the pitch around the given center pitch' do
        note.invert(Pitch 54).should == NOTE.new(Pitch(48), duration, intensity)
      end
    end

    it "returns the an equal note when given it's pitch as an argument" do
      note.invert(note.pitch).should == note
    end
  end

  describe "#==" do
    it "is true when the pitches, intensities, and durations are equal" do
      note.should == NOTE.new(pitch, duration, intensity)
    end

    it "is false when the pitches are not equal" do
      note.should_not == NOTE.new(pitch + 1, duration, intensity)
    end

    it "is false when the intensities are not equal" do
      note.should_not == NOTE.new(pitch, duration, intensity * 0.5)
    end

    it "is false when the durations are not equal" do
      note.should_not == NOTE.new(pitch, duration * 2, intensity)
    end
  end

  describe "#to_s" do
    it "includes the #pitch, #intensity to 2 decimal places, and #duration to 2 decimal places" do
      NOTE.new(C4, Duration(1/3.0), Intensity(1/3.0)).to_s.should == "Note(C4, 0.33 beat, 33%)"
    end
  end

  describe "#inspect" do
    it 'is "#<MTK::Events::Note:{object_id} @pitch={pitch.inspect}, @duration={duration.inspect}, @intensity={intensity.inspect}>"' do
      duration = MTK.Duration(1/8.0)
      intensity = MTK.Intensity(1/8.0)
      note = NOTE.new(C4, duration, intensity)
      note.inspect.should == "#<MTK::Events::Note:#{note.object_id} @pitch=#{C4.inspect}, @duration=#{duration.inspect}, @intensity=#{intensity.inspect}>"
    end
  end

end


describe MTK do

  describe '#Note' do

    it "acts like new for multiple arguments" do
      Note(C4,q,mf).should == NOTE.new(C4,q,mf)
    end

    it "acts like new for an Array of arguments by unpacking (splatting) them" do
      Note([C4,q,mf]).should == NOTE.new(C4,q,mf)
    end

    it "returns the argument if it's already a Note" do
      note = NOTE.new(C4,q,mf)
      Note(note).should be_equal(note)
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Note({:not => :compatible}) }.should raise_error
    end

    it "handles out of order arguments for recognized types (Pitch, Duration, Intensity)" do
      Note(q,mf,C4).should == NOTE.new(C4,q,mf)
    end

    it "fills in a missing duration type from an number" do
      Note(C4,mf,5.25).should == NOTE.new(C4,MTK.Duration(5.25),mf)
    end

    it '' do
      Note(MTK::Lang::Pitches::C4, MTK::Lang::Intensities::o, 5.25).should == Note(C4, 5.25, 0.75)
    end

  end

end

