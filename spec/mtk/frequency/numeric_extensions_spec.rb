require 'spec_helper'
module MTK::Frequency

  describe Numeric do

    describe '#hz' do
      it "should convert the number to a Hertz" do
        100.hz.should be_a Hertz
      end

      it "should convert the number to a Scalar with a value of the number" do
        100.hz.value.should == 100
      end
    end

    describe '#Hz' do
      it "should convert the number to a Hertz" do
        100.Hz.should be_a Hertz
      end

      it "should convert the number to a Scalar with a value of the number" do
        100.Hz.value.should == 100
      end
    end


    describe '#khz' do
      it "should convert the number to a Kilohertz" do
        100.khz.should be_a Kilohertz
      end

      it "should convert the number to a Scalar with a value of the number" do
        100.khz.value.should == 100
      end
    end

    describe '#kHz' do
      it "should convert the number to a Kilohertz" do
        100.kHz.should be_a Kilohertz
      end

      it "should convert the number to a Scalar with a value of the number" do
        100.kHz.value.should == 100
      end
    end


    describe '#cents' do
      it "should convert the number to a Cents" do
        100.cents.should be_a Cents
      end

      it "should convert the number to a Scalar with a value of the number" do
        100.cents.value.should == 100
      end
    end


    describe '#semitones' do
      it "should convert the number to a Semitones" do
        100.semitones.should be_a Semitones
      end

      it "should convert the number to a Scalar with a value of the number" do
        100.semitones.value.should == 100
      end
    end
  end
end
