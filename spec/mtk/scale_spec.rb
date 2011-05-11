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

  end
end
