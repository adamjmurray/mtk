require 'spec_helper'

describe MTK::PitchClassSet do

  let(:pitch_classes) { [C,E,G] }
  let(:pitch_class_set) { PitchClassSet.new(pitch_classes) }

  it "is Enumerable" do
    pitch_class_set.should be_a Enumerable
  end

  describe ".random_row" do
    it "generates a 12-tone row" do
      PitchClassSet.random_row.should =~ PitchClasses::PITCH_CLASSES
    end

    it "generates a random 12-tone row (very slight expected chance of test failure, if this fails run it again!)" do
      # there's a 1/479_001_600 chance this will fail... whaddyagonnado??
      PitchClassSet.random_row.should_not == PitchClassSet.random_row
    end
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
  end

  describe "#to_a" do
    it "is equal to #pitch_classes" do
      pitch_class_set.to_a.should == pitch_class_set.pitch_classes
    end

    it "is mutable" do
      (pitch_class_set.to_a << Bb).should == [C, E, G, Bb]
    end
  end

  describe "#size" do
    it "returns the number of pitch classes in the set" do
      pitch_class_set.size.should == 3
    end
  end

  describe "#length" do
    it "behaves like #size" do
      pitch_class_set.length.should == pitch_class_set.size
    end
  end

  describe "#[]" do
    it "accesses the individual pitch classes (like an Array)" do
      pitch_class_set[0].should == C
      pitch_class_set[1].should == E
      pitch_class_set[2].should == G
    end

    it "returns nil for invalid indexes" do
      pitch_class_set[pitch_class_set.size].should == nil
    end
  end

  describe "#first" do
    it "is #[0]" do
      pitch_class_set.first.should == pitch_class_set[0]
    end
  end

  describe "#last" do
    it "is #[-1]" do
      pitch_class_set.last.should == pitch_class_set[-1]
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

  describe '#transpose' do
    it 'transposes by the given semitones' do
      (pitch_class_set.transpose 4.semitones).should == PitchClassSet(E, Ab, B)
    end
  end

  describe "#invert" do
    it 'inverts all pitch_classes around the given center pitch' do
      pitch_class_set.invert(G).should == PitchClassSet(D,Bb,G)
    end

    it 'inverts all pitches around the first pitch, when no center pitch is given' do
      pitch_class_set.invert.should == PitchClassSet(C,Ab,F)
    end
  end

  describe "#reverse" do
    it "produces a PitchClassSet with pitch classes in reverse order" do
      pitch_class_set.reverse.should == PitchClassSet(G,E,C)
    end
  end

  describe "#retrograde" do
    it "acts like reverse" do
      pitch_class_set.retrograde.should == pitch_class_set.reverse
    end
  end

  describe "#intersection" do
    it "produces a PitchClassSet containing the common pitch classes from self and the argument" do
      pitch_class_set.intersection(PitchClassSet(E,G,B)).should == PitchClassSet(E,G)
    end
  end

  describe "#union" do
    it "produces a PitchClassSet containing the all pitch classes from either self or the argument" do
      pitch_class_set.union(PitchClassSet(E,G,B)).should == PitchClassSet(C,E,G,B)
    end
  end

  describe "#difference" do
    it "produces a PitchClassSet with the pitch classes from the argument removed" do
      pitch_class_set.difference(PitchClassSet(E)).should == PitchClassSet(C,G)
    end
  end

  describe "#symmetric_difference" do
    it "produces a PitchClassSet containing the pitch classes only in self or only in the argument" do
      pitch_class_set.symmetric_difference(PitchClassSet(E,G,B)).should == PitchClassSet(C,B)
    end
  end

  describe "#normal_order" do
    it "permutes the set so that the first and last pitch classes are as close together as possible" do
      PitchClassSet.new([E,A,C]).normal_order.should == [A,C,E]
    end

    it "breaks ties by minimizing the distance between the first and second-to-last pitch class" do
      # 0,4,8,9,11
      PitchClassSet.new([C,E,Ab,A,B]).normal_order.should == [Ab,A,B,C,E]
    end

  end

  describe "#normal_form" do
    it "is transposes the #normal_order so that the first pitch class set is 0 (C)" do
      PitchClassSet.new([E,A,C]).normal_form.should == [0,3,7]
    end

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

  describe "#==" do
    it "is true if two pitch class sets contain the same set in the same order" do
      pitch_class_set.should == PitchClassSet(C,E,G)
    end

    it "is false if two pitch class sets are not in the same order" do
      pitch_class_set.should_not == PitchClassSet(C,G,E)
    end

    it "is false if two pitch class sets do not contain the same pitch classes" do
      pitch_class_set.should_not == PitchClassSet(C,E)
    end

    it "allows for direct comparison with Arrays" do
       pitch_class_set.should == [C,E,G]
    end
  end

  describe "#=~" do
    it "is true if two pitch class sets contain the same set in the same order" do
      pitch_class_set.should =~ PitchClassSet(C,E,G)
    end

    it "is true if two pitch class sets are not in the same order" do
      pitch_class_set.should =~ PitchClassSet(C,G,E)
    end

    it "is false if two pitch class sets do not contain the same pitch classes" do
      pitch_class_set.should_not =~ PitchClassSet(C,E)
    end

    it "allows for direct comparison with Arrays" do
       pitch_class_set.should =~ [C,G,E]
    end
  end

  describe ".span_between" do
    it "is the distance in semitones between 2 pitch classes" do
      PitchClassSet.span_between(F, Bb).should == 5
    end

    it "assumes an ascending interval between the arguments (order of arguments matters)" do
      PitchClassSet.span_between(Bb, F).should == 7
    end
  end

  describe ".span_for" do
    it "measure the distance between the first and last pitch classes" do
      PitchClassSet.span_for([C,D,E,F,G]).should == 7
    end
  end

end

describe MTK do

  describe '#PitchClassSet' do

    it "acts like new for a single Array argument" do
      PitchClassSet([C,D]).should == PitchClassSet.new([C,D])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      PitchClassSet(C,D).should == PitchClassSet.new([C,D])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      PitchClassSet(['C','D']).should == PitchClassSet.new([C,D])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      PitchClassSet(:C,:D).should == PitchClassSet.new([C,D])
    end

    it "handles a single Pitch" do
      PitchClassSet(C).should == PitchClassSet.new([C])
    end

    it "handles single elements that can be converted to a Pitch" do
      PitchClassSet('C').should == PitchClassSet.new([C])
    end

    it "returns the argument if it's already a PitchClassSet" do
      pitch_set = PitchClassSet.new([C,D])
      PitchClassSet(pitch_set).should be_equal pitch_set
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchClassSet({:not => :compatible}) }.should raise_error
    end

  end

end