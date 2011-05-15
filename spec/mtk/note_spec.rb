require 'spec_helper'

describe MTK::Note do
  include Intervals
  include Dynamics

  let(:pitch) { C4 }
  let(:intensity) { MF }
  let(:duration) { 2.5 }
  let(:note) { Note.new(pitch, intensity, duration) }

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

end
