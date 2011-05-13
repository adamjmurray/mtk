require 'spec_helper'
module MTK::Scale::Spec
  include MTK::Pitch::Constants
  include MTK::PitchClass::Constants

  describe MTK::Scale do

    before do
      @pitches = [C4, D4, E4, F4, G4, A4, B4]
      @subject = Scale.new(@pitches)
    end

    describe '#pitches' do
      it 'is the list of pitches used to construct the scale' do
        @subject.pitches.should == @pitches
      end

      it 'is immutable' do
        lambda { @subject.pitches << Db4 }.should raise_error
      end

      it 'does not affect the immutabilty of the pitch list used to construct the scale' do
        @pitches << Db4
        @pitches.length.should == 8
      end

      it 'is not affected by changes to the pitch list used to construct the scale' do
        @pitches << Db4
        @subject.pitches.length.should == 7
      end
    end

    describe '#pitch_classes' do
      it 'is the list of pitch classes' do
        @subject.pitch_classes.should == @pitches.map{|p| p.pitch_class }
      end

      it "doesn't include duplicates" do
        Scale.new([C4, C5, D5, C6, D4]).pitch_classes.should == [C, D]
      end
    end

    describe '#+' do
      it 'transposes upward by the given semitones' do
        (@subject + 12).should == Scale.new([C5, D5, E5, F5, G5, A5, B5])
      end
    end

    describe '#-' do
      it 'transposes downward by the given semitones' do
        (@subject - 12).should == Scale.new([C3, D3, E3, F3, G3, A3, B3])
      end
    end

    describe '#invert' do
      it 'inverts all pitches around the given center pitch' do
        (@subject.invert Gb4).should == Scale.new([C5, Bb4, Ab4, G4, F4, Eb4, Db4])
      end
    end

    describe '#include?' do
      it 'returns true if the Pitch is in the Scale' do
        (@subject.include? C4).should be_true
      end

      it 'returns false if the Pitch is not in the Scale' do
        (@subject.include? Db4).should be_false
      end
    end
  end
end
