require 'spec_helper'

describe MTK::PitchClassSet do

  let(:pitch_classes) { [C,E,G] }
  let(:pitch_class_set) { PitchClassSet.new(pitch_classes) }

  it "is Enumerable" do
    pitch_class_set.should be_a Enumerable
  end

  describe "#pitch_classes" do
    it "is the list of pitch_classes contained in this set" do
      pitch_class_set.pitch_classes.should == pitch_classes
    end

    it "is immutable" do
      lambda { pitch_class_set.pitch_classes << D }.should raise_error
    end

    it "does not affect the immutabilty of the pitch class list used to construct it" do
      pitch_classes << D
      pitch_classes.length.should == 4
    end

    it "is not affected by changes to the pitch class list used to construct it" do
      pitch_class_set # force construction before we modify the pitch_classes array
      pitch_classes << D
      pitch_class_set.pitch_classes.length.should == 3
    end

    it "does not include duplicates" do
      PitchClassSet.new([C, E, G, C]).pitch_classes.should == [C, E, G]
    end

    it "sorts the pitch_classes (C to B)" do
      PitchClassSet.new([B, E, C]).pitch_classes.should == [C, E, B]
    end
  end

  describe "#to_a" do
    it "is equal to #pitch_classes" do
      pitch_class_set.to_a.should == pitch_class_set.pitch_classes
    end

    it "is mutable" do
      (pitch_class_set.to_a << Bb).should == [C, E, G, Bb]
    end
  end

  describe "#each" do
    it "yields each pitch_class" do
      pcs = []
      pitch_class_set.each{|pc| pcs << pc }
      pcs.should == pitch_classes
    end
  end

  describe "#map" do
    it "returns a PitchClassSet with each PitchClass replaced with the results of the block" do
      pitch_class_set.map{|pc| pc + 2}.should == [D, Gb, A]
    end
  end

  describe "#normal_form" do
    it "is invariant across reorderings of the pitch classes" do
      PitchClassSet.new([C,E,G]).normal_form.should == [0,4,7]
      PitchClassSet.new([E,C,G]).normal_form.should == [0,4,7]
      PitchClassSet.new([G,E,C]).normal_form.should == [0,4,7]
    end

    it "is invariant across transpositions" do
      PitchClassSet.new([C,Eb,G]).normal_form.should == [0,3,7]
      PitchClassSet.new([Db,E,Ab]).normal_form.should == [0,3,7]
      PitchClassSet.new([Bb,F,Db]).normal_form.should == [0,3,7]
    end
  end

end
