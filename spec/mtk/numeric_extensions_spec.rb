require 'spec_helper'

describe Numeric do

  describe '#semitones' do
    it "is the Numeric value" do
      100.semitones.should == 100
    end
  end

  describe "#cents" do
    it "is the Numeric / 100.0" do
      100.cents.should == 1
    end
  end

  describe "#minor_seconds" do
    it "is the Numeric value" do
      2.minor_seconds.should == 2
    end
  end

  describe "#major_seconds" do
    it "is the Numeric * 2" do
      2.major_seconds.should == 4
    end
  end

  describe "#minor_thirds" do
    it "is the Numeric * 3" do
      2.minor_thirds.should == 6
    end
  end

  describe "#major_thirds" do
    it "is the Numeric * 4" do
      2.major_thirds.should == 8
    end
  end

  describe "#perfect_fourths" do
    it "is the Numeric * 5" do
      2.perfect_fourths.should == 10
    end
  end

  describe "#tritones" do
    it "is the Numeric * 6" do
      2.tritones.should == 12
    end
  end

  describe "#augmented_fourths" do
    it "is the Numeric * 6" do
      2.augmented_fourths.should == 12
    end
  end

  describe "#diminshed_fifths" do
    it "is the Numeric * 6" do
      2.diminshed_fifths.should == 12
    end
  end

  describe "#perfect_fifths" do
    it "is the Numeric * 7" do
      2.perfect_fifths.should == 14
    end
  end

  describe "#minor_sixths" do
    it "is the Numeric * 8" do
      2.minor_sixths.should == 16
    end
  end

  describe "#major_sixths" do
    it "is the Numeric * 9" do
      2.major_sixths.should == 18
    end
  end

  describe "#minor_sevenths" do
    it "is the Numeric * 10" do
      2.minor_sevenths.should == 20
    end
  end

  describe "#major_sevenths" do
    it "is the Numeric * 11" do
      2.major_sevenths.should == 22
    end
  end

  describe "#octaves" do
    it "is the Numeric * 12" do
      2.octaves.should == 24
    end
  end

end

