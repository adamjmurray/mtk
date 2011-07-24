require 'spec_helper'

describe MTK::PitchClassList do

  let(:pitch_classes) { [C,E,G] }
  let(:pitch_class_list) { PitchClassList.new(pitch_classes) }

  it "is Enumerable" do
    pitch_class_list.should be_a Enumerable
  end

  describe ".random_row" do
    it "generates a 12-tone row" do
      PitchClassList.random_row.should =~ PitchClasses::PITCH_CLASSES
    end

    it "generates a random 12-tone row (NOTE: very slight expected chance of test failure, if this fails run it again!)" do
      # there's a 1/479_001_600 chance this will fail... whaddyagonnado??
      PitchClassList.random_row.should_not == PitchClassList.random_row
    end
  end

  describe ".all" do
    it "is the set of all 12 pitch classes" do
      PitchClassList.all.should == PitchClassList(PitchClasses::PITCH_CLASSES)
    end
  end

  describe ".new" do
    it "maintains the pitch class collection exactly (preserves order and keeps duplicates) by default" do
      PitchClassList.new([C, E, G, E, B, C]).pitch_classes.should == [C, E, G, E, B, C]
    end
  end

  describe "#pitch_classes" do
    it "is the list of pitch_classes contained in this set" do
      pitch_class_list.pitch_classes.should == pitch_classes
    end

    it "is immutable" do
      lambda { pitch_class_list.pitch_classes << D }.should raise_error
    end

    it "does not affect the immutabilty of the pitch class list used to construct it" do
      pitch_classes << D
      pitch_classes.length.should == 4
    end

    it "is not affected by changes to the pitch class list used to construct it" do
      pitch_class_list # force construction before we modify the pitch_classes array
      pitch_classes << D
      pitch_class_list.pitch_classes.length.should == 3
    end
  end

  describe "#to_a" do
    it "is equal to #pitch_classes" do
      pitch_class_list.to_a.should == pitch_class_list.pitch_classes
    end

    it "is mutable" do
      (pitch_class_list.to_a << Bb).should == [C, E, G, Bb]
    end
  end

  describe "#size" do
    it "returns the number of pitch classes in the set" do
      pitch_class_list.size.should == 3
    end
  end

  describe "#length" do
    it "behaves like #size" do
      pitch_class_list.length.should == pitch_class_list.size
    end
  end

  describe "#[]" do
    it "accesses the individual pitch classes (like an Array)" do
      pitch_class_list[0].should == C
      pitch_class_list[1].should == E
      pitch_class_list[2].should == G
    end

    it "returns nil for invalid indexes" do
      pitch_class_list[pitch_class_list.size].should == nil
    end
  end

  describe "#first" do
    it "is #[0]" do
      pitch_class_list.first.should == pitch_class_list[0]
    end
  end

  describe "#last" do
    it "is #[-1]" do
      pitch_class_list.last.should == pitch_class_list[-1]
    end
  end

  describe "#each" do
    it "yields each pitch_class" do
      pcs = []
      pitch_class_list.each{|pc| pcs << pc }
      pcs.should == pitch_classes
    end
  end

  describe "#map" do
    it "returns a PitchClassList with each PitchClass replaced with the results of the block" do
      pitch_class_list.map{|pc| pc + 2}.should == [D, Gb, A]
    end
  end

  describe '#transpose' do
    it 'transposes by the given semitones' do
      (pitch_class_list.transpose 4.semitones).should == PitchClassList(E, Ab, B)
    end
  end

  describe "#invert" do
    it 'inverts all pitch_classes around the given center pitch' do
      pitch_class_list.invert(G).should == PitchClassList(D,Bb,G)
    end

    it 'inverts all pitches around the first pitch, when no center pitch is given' do
      pitch_class_list.invert.should == PitchClassList(C,Ab,F)
    end
  end

  describe "#reverse" do
    it "produces a PitchClassList with pitch classes in reverse order" do
      pitch_class_list.reverse.should == PitchClassList(G,E,C)
    end
  end

  describe "#retrograde" do
    it "acts like reverse" do
      pitch_class_list.retrograde.should == pitch_class_list.reverse
    end
  end

  describe "#intersection" do
    it "produces a PitchClassList containing the common pitch classes from self and the argument" do
      pitch_class_list.intersection(PitchClassList(E,G,B)).should == PitchClassList(E,G)
    end
  end

  describe "#union" do
    it "produces a PitchClassList containing the all pitch classes from either self or the argument" do
      pitch_class_list.union(PitchClassList(E,G,B)).should == PitchClassList(C,E,G,B)
    end
  end

  describe "#difference" do
    it "produces a PitchClassList with the pitch classes from the argument removed" do
      pitch_class_list.difference(PitchClassList(E)).should == PitchClassList(C,G)
    end
  end

  describe "#symmetric_difference" do
    it "produces a PitchClassList containing the pitch classes only in self or only in the argument" do
      pitch_class_list.symmetric_difference(PitchClassList(E,G,B)).should == PitchClassList(C,B)
    end
  end

  describe "#complement" do
    it "produces the set of all PitchClasses not in the current set" do
      pitch_class_list.complement.should =~ PitchClassList(Db,D,Eb,F,Gb,Ab,A,Bb,B)
    end
  end

  describe "#rotate" do
    it "produces a PitchClassList that is rotated by the given offset" do
      pitch_class_list.rotate(2).should == PitchClassList(G,C,E)
      pitch_class_list.rotate(-2).should == PitchClassList(E,G,C)
    end

    it "rotates by 1 if no argument is given" do
      pitch_class_list.rotate.should == pitch_class_list.rotate(1)
    end
  end

  describe "#permute" do
    it "randomly rearranges the PitchClassList order (NOTE: very slight expected chance of test failure, if this fails run it again!)" do
      all_pcs = PitchClassList(PitchClasses::PITCH_CLASSES)
      permuted = all_pcs.permute
      permuted.should =~ all_pcs
      permuted.should_not == all_pcs # there's a 1/479_001_600 chance this will fail...
    end
  end

  describe "#shuffle" do
    it "behaves like permute (NOTE: very slight expected chance of test failure, if this fails run it again!)" do
      all_pcs = PitchClassList(PitchClasses::PITCH_CLASSES)
      shuffled = all_pcs.shuffle
      shuffled.should =~ all_pcs
      shuffled.should_not == all_pcs # there's a 1/479_001_600 chance this will fail...
    end
  end

  describe "#concat" do
    it "appends the pitch classes from the other set" do
      pitch_class_list.concat(PitchClassList(D,E,F)).should == PitchClassList(C,E,G,D,E,F)
    end
  end

  describe "#normal_order" do
    it "permutes the set so that the first and last pitch classes are as close together as possible" do
      PitchClassList.new([E,A,C]).normal_order.should == [A,C,E]
    end

    it "breaks ties by minimizing the distance between the first and second-to-last pitch class" do
      # 0,4,8,9,11
      PitchClassList.new([C,E,Ab,A,B]).normal_order.should == [Ab,A,B,C,E]
    end

  end

  describe "#normal_form" do
    it "is transposes the #normal_order so that the first pitch class set is 0 (C)" do
      PitchClassList.new([E,A,C]).normal_form.should == [0,3,7]
    end

    it "is invariant across reorderings of the pitch classes" do
      PitchClassList.new([C,E,G]).normal_form.should == [0,4,7]
      PitchClassList.new([E,C,G]).normal_form.should == [0,4,7]
      PitchClassList.new([G,E,C]).normal_form.should == [0,4,7]
    end

    it "is invariant across transpositions" do
      PitchClassList.new([C,Eb,G]).normal_form.should == [0,3,7]
      PitchClassList.new([Db,E,Ab]).normal_form.should == [0,3,7]
      PitchClassList.new([Bb,F,Db]).normal_form.should == [0,3,7]
    end
  end

  describe "#==" do
    it "is true if two pitch class sets contain the same set in the same order" do
      pitch_class_list.should == PitchClassList(C,E,G)
    end

    it "is false if two pitch class sets are not in the same order" do
      pitch_class_list.should_not == PitchClassList(C,G,E)
    end

    it "is false when if otherwise equal pitch class sets don't contain the same number of duplicates" do
      PitchClassList.new([C, E, G]).should_not == PitchClassList.new([C, C, E, G])
    end

    it "is false if two pitch class sets do not contain the same pitch classes" do
      pitch_class_list.should_not == PitchClassList(C,E)
    end

    it "allows for direct comparison with Arrays" do
       pitch_class_list.should == [C,E,G]
    end
  end

  describe "#=~" do
    it "is true if two pitch class sets contain the same set in the same order" do
      pitch_class_list.should =~ PitchClassList(C,E,G)
    end

    it "is true when all the pitch classes are equal, even with different numbers of duplicates" do
      PitchSet.new([C, E, G]).should =~ PitchSet.new([C, C, E, G])
    end

    it "is true if two pitch class sets are not in the same order" do
      pitch_class_list.should =~ PitchClassList(C,G,E)
    end

    it "is false if two pitch class sets do not contain the same pitch classes" do
      pitch_class_list.should_not =~ PitchClassList(C,E)
    end

    it "allows for direct comparison with Arrays" do
       pitch_class_list.should =~ [C,G,E]
    end
  end

  describe ".span_between" do
    it "is the distance in semitones between 2 pitch classes" do
      PitchClassList.span_between(F, Bb).should == 5
    end

    it "assumes an ascending interval between the arguments (order of arguments matters)" do
      PitchClassList.span_between(Bb, F).should == 7
    end
  end

  describe ".span_for" do
    it "measure the distance between the first and last pitch classes" do
      PitchClassList.span_for([C,D,E,F,G]).should == 7
    end
  end

end

describe MTK do

  describe '#PitchClassList' do

    it "acts like new for a single Array argument" do
      PitchClassList([C,D]).should == PitchClassList.new([C,D])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      PitchClassList(C,D).should == PitchClassList.new([C,D])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      PitchClassList(['C','D']).should == PitchClassList.new([C,D])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      PitchClassList(:C,:D).should == PitchClassList.new([C,D])
    end

    it "handles a single Pitch" do
      PitchClassList(C).should == PitchClassList.new([C])
    end

    it "handles single elements that can be converted to a Pitch" do
      PitchClassList('C').should == PitchClassList.new([C])
    end

    it "handles a PitchClassList" do
      pitch_set = PitchClassList.new([C,D])
      PitchClassList(pitch_set).should == [C,D]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchClassList({:not => :compatible}) }.should raise_error
    end

  end

end