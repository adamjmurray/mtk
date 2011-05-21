require 'spec_helper'

describe MTK::Note do

  let(:pitch) { C4 }
  let(:intensity) { mf }
  let(:duration) { 2.5 }
  let(:note) { Note.new(pitch, intensity, duration) }

  describe 'from_midi' do
    pending
  end

  describe '#transpose' do
    it 'adds the given interval to the @pitch' do
      (note.transpose 2.semitones).should == Note.new(D4, intensity, duration)
    end
    it 'does not affect the immutability of the Note' do
      (note.transpose 2.semitones).should_not == note
    end
  end

  describe '#scale_intensity' do
    it 'multiplies @intensity by the argument' do
      (note.scale_intensity 0.5).should == Note.new(pitch, intensity * 0.5, duration)
    end
    it 'does not affect the immutability of the Note' do
      (note.scale_intensity 0.5).should_not == note
    end
  end

  describe '#scale_duration' do
    it 'multiplies @duration by the argument' do
      (note.scale_duration 2).should == Note.new(pitch, intensity, duration*2)
    end
    it 'does not affect the immutability of the Note' do
      (note.scale_duration 0.5).should_not == note
    end
  end

  describe "#velocity" do
    it "converts intensities in the range 0.0-1.0 to a MIDI velocity in the range 0-127" do
      Note.new(C4, 0, 0).velocity.should == 0
      Note.new(C4, 1, 0).velocity.should == 127
    end
    it "rounds to the nearest MIDI velocity" do
      Note.new(C4, 0.5, 0).velocity.should == 64 # not be truncated to 63!
    end
  end

  describe "#to_s" do
    pending
  end

  describe "#inspect" do
    pending
  end

end
