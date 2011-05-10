require 'spec_helper'
module MTK::Pitch::Constants

  describe MTK::Scale do

    let(:pitches) { [C4, D4, E4, F4, G4, A4, B4] }
    subject { Scale.new(pitches) }

    describe '#pitches' do
      it 'is the list of pitches used to construct the scale' do
        subject.pitches.should == pitches
      end

      it 'is be immutable' do
        lambda {
          subject.pitches << Db4
        }.should raise_error
      end

      it 'does not affect the immutabilty of the pitch list used to construct the scale' do
        pitches << Db4
        pitches.length.should == 8
      end

      it 'is not affected by changes to the pitch list used to construct the scale' do
        subject
        pitches << Db4
        subject.pitches.length.should == 7
      end
    end

  end

end
