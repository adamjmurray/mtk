require 'spec_helper'
require 'mtk/numeric_extensions'

describe Numeric do

  describe "#to_pitch" do
    it "acts like Pitch.from_f applied to the Numeric value" do
      12.3.to_pitch.should == MTK::Core::Pitch.from_f(12.3)
    end
  end


  describe "#to_pitch_class" do
    it "acts like PitchClass.from_f applied to the Numeric value" do
      6.to_pitch_class.should == MTK::Core::PitchClass.from_f(6)
    end
  end


  describe "#to_duration" do
    it "acts like Duration.from_f applied to the Numeric value" do
      1.5.to_duration.should == MTK::Core::Duration.from_f(1.5)
    end
  end

  describe "#beat" do
    it "acts like #to_duration" do
      1.beat.should == 1.to_duration
    end
  end

  describe "#beats" do
    it "acts like #to_duration" do
      2.beats.should == 2.to_duration
    end
  end


  describe "#to_intensity" do
    it "acts like Intensity.from_f applied to the Numeric value" do
      0.75.to_intensity.should == MTK::Core::Intensity.from_f(0.75)
    end
  end

  describe "#percent_intensity" do
    it "acts like Intensity.from_f applied to 1/100 of the Numeric value" do
      75.percent_intensity.should == MTK::Core::Intensity.from_f(0.75)
    end
  end


  describe "#to_interval" do
    it "acts like Interval.from_f applied to the Numeric value" do
      3.5.to_interval.should == MTK::Core::Interval.from_f(3.5)
    end
  end

  describe '#semitone' do
    it "acts like #to_interval" do
      1.semitone.should == 1.to_interval
    end
  end

  describe '#semitones' do
    it "acts like #to_interval" do
      2.semitones.should == 2.to_interval
    end
  end

  describe "#cents" do
    it "acts like Interval.from_f applied to 1/100 of the Numeric value" do
      50.cents.should == MTK::Core::Interval.from_f(0.5)
    end
  end

  describe "#octaves" do
    it "acts like Interval.from_f applied to 12 times the Numeric value" do
      2.octaves.should == MTK::Core::Interval.from_f(24)
    end
  end

end

