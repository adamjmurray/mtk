require 'spec_helper'

describe MTK::PitchList do

  let(:pitches) { [C4, D4, E4, F4, G4, A4, B4] }
  let(:pitch_list) { PitchList.new(pitches) }
    
  describe '#pitches' do
    it 'is the list of pitches used to construct the scale' do
      pitch_list.pitches.should == pitches
    end

    it 'is immutable' do
      lambda { pitch_list.pitches << Db4 }.should raise_error
    end

    it 'does not affect the immutabilty of the pitch list used to construct the scale' do
      pitches << Db4
      pitches.length.should == 8
    end

    it 'is not affected by changes to the pitch list used to construct the scale' do
      pitch_list # force construction before we modify the pitches array
      pitches << Db4
      pitch_list.pitches.length.should == 7
    end
  end

  describe '#pitch_classes' do
    it 'is the list of pitch classes' do
      pitch_list.pitch_classes.should == pitches.map { |p| p.pitch_class }
    end

    it "doesn't include duplicates" do
      PitchList.new([C4, C5, D5, C6, D4]).pitch_classes.should == [C, D]
    end
  end

  describe '#+' do
    it 'transposes upward by the given semitones' do
      (pitch_list + 12).should == PitchList.new([C5, D5, E5, F5, G5, A5, B5])
    end
  end

  describe '#-' do
    it 'transposes downward by the given semitones' do
      (pitch_list - 12).should == PitchList.new([C3, D3, E3, F3, G3, A3, B3])
    end
  end

  describe '#invert' do
    it 'inverts all pitches around the given center pitch' do
      (pitch_list.invert Gb4).should == PitchList.new([C5, Bb4, Ab4, G4, F4, Eb4, Db4])
    end

    it 'inverts all pitches around the first pitch, when no center pitch is given' do
      pitch_list.invert.should == PitchList.new([C4, Bb3, Ab3, G3, F3, Eb3, Db3])
    end
  end

  describe '#include?' do
    it 'returns true if the Pitch is in the PitchList' do
      (pitch_list.include? C4).should be_true
    end

    it 'returns false if the Pitch is not in the PitchList' do
      (pitch_list.include? Db4).should be_false
    end
  end
end
