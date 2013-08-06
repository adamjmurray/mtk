require 'spec_helper'

describe MTK::Groups::PitchClassGroup do

  PITCH_CLASS_GROUP = MTK::Groups::PitchClassGroup

  let(:pitch_classes) { [C,E,G] }
  let(:pitch_class_group) { MTK::Groups::PitchClassGroup.new(pitch_classes) }

  it "is Enumerable" do
    pitch_class_group.should be_a Enumerable
  end


  describe ".random_tone_row" do
    it "generates a 12-tone row" do
      PITCH_CLASS_SET.random_tone_row.should =~ PitchClasses::PITCH_CLASSES
    end

    it "generates a random 12-tone row (NOTE: very slight expected chance of test failure, if this fails run it again!)" do
      # there's a 1/479_001_600 chance this will fail... whaddyagonnado??
      PITCH_CLASS_SET.random_tone_row.should_not == PITCH_CLASS_SET.random_tone_row
    end
  end


  describe ".new" do
    it "maintains the pitch class collection exactly (preserves order and keeps duplicates)" do
      PITCH_CLASS_GROUP.new([C, E, G, E, B, C]).pitch_classes.should == [C, E, G, E, B, C]
    end
  end

  describe "#pitch_classes" do
    it "is the list of pitch_classes contained in this set" do
      pitch_class_group.pitch_classes.should == pitch_classes
    end

    it "is immutable" do
      lambda { pitch_class_group.pitch_classes << D }.should raise_error
    end

    it "does not affect the immutabilty of the pitch class list used to construct it" do
      pitch_classes << D
      pitch_classes.length.should == 4
    end

    it "is not affected by changes to the pitch class list used to construct it" do
      pitch_class_group # force construction before we modify the pitch_classes array
      pitch_classes << D
      pitch_class_group.pitch_classes.length.should == 3
    end
  end

  describe "#to_a" do
    it "is equal to #pitch_classes" do
      pitch_class_group.to_a.should == pitch_class_group.pitch_classes
    end

    it "is mutable" do
      (pitch_class_group.to_a << Bb).should == [C, E, G, Bb]
    end
  end

  describe "#size" do
    it "returns the number of pitch classes in the set" do
      pitch_class_group.size.should == 3
    end
  end

  describe "#length" do
    it "behaves like #size" do
      pitch_class_group.length.should == pitch_class_group.size
    end
  end

  describe "#[]" do
    it "accesses the individual pitch classes (like an Array)" do
      pitch_class_group[0].should == C
      pitch_class_group[1].should == E
      pitch_class_group[2].should == G
    end

    it "returns nil for invalid indexes" do
      pitch_class_group[pitch_class_group.size].should == nil
    end
  end

  describe "#first" do
    it "is #[0]" do
      pitch_class_group.first.should == pitch_class_group[0]
    end
  end

  describe "#last" do
    it "is #[-1]" do
      pitch_class_group.last.should == pitch_class_group[-1]
    end
  end

  describe "#each" do
    it "yields each pitch_class" do
      pcs = []
      pitch_class_group.each{|pc| pcs << pc }
      pcs.should == pitch_classes
    end
  end

  describe "#map" do
    it "returns a PITCH_CLASS_GROUP with each PitchClass replaced with the results of the block" do
      pitch_class_group.map{|pc| pc + 2}.should == [D, Gb, A]
    end
  end

  describe '#transpose' do
    it 'transposes by the given semitones' do
      (pitch_class_group.transpose 4).should == MTK.PitchClassGroup(E, Ab, B)
    end
  end

  describe "#invert" do
    it 'inverts all pitch_classes around the given center pitch' do
      pitch_class_group.invert(G).should == MTK.PitchClassGroup(D,Bb,G)
    end

    it 'inverts all pitches around the first pitch, when no center pitch is given' do
      pitch_class_group.invert.should == MTK.PitchClassGroup(C,Ab,F)
    end
  end

  describe "#reverse" do
    it "produces a PITCH_CLASS_GROUP with pitch classes in reverse order" do
      pitch_class_group.reverse.should == MTK.PitchClassGroup(G,E,C)
    end
  end

  describe "#rotate" do
    it "produces a PITCH_CLASS_GROUP that is rotated by the given offset" do
      pitch_class_group.rotate(2).should == MTK.PitchClassGroup(G,C,E)
      pitch_class_group.rotate(-2).should == MTK.PitchClassGroup(E,G,C)
    end

    it "rotates by 1 if no argument is given" do
      pitch_class_group.rotate.should == pitch_class_group.rotate(1)
    end
  end

  describe "#permute" do
    it "randomly rearranges the PITCH_CLASS_GROUP order (NOTE: very slight expected chance of test failure, if this fails run it again!)" do
      all_pcs = MTK.PitchClassGroup(PitchClasses::PITCH_CLASSES)
      permuted = all_pcs.permute
      permuted.should =~ all_pcs
      permuted.should_not == all_pcs # there's a 1/479_001_600 chance this will fail...
    end
  end

  describe "#shuffle" do
    it "behaves like permute (NOTE: very slight expected chance of test failure, if this fails run it again!)" do
      all_pcs = MTK.PitchClassGroup(PitchClasses::PITCH_CLASSES)
      shuffled = all_pcs.shuffle
      shuffled.should =~ all_pcs
      shuffled.should_not == all_pcs # there's a 1/479_001_600 chance this will fail...
    end
  end

  describe "#concat" do
    it "appends the pitch classes from the other set" do
      pitch_class_group.concat(MTK.PitchClassGroup(D,E,F)).should == MTK.PitchClassGroup(C,E,G,D,E,F)
    end
  end

  describe "#==" do
    it "is true if two pitch class sets contain the same set in the same order" do
      pitch_class_group.should == MTK.PitchClassGroup(C,E,G)
    end

    it "is false if two pitch class sets are not in the same order" do
      pitch_class_group.should_not == MTK.PitchClassGroup(C,G,E)
    end

    it "is false when if otherwise equal pitch class sets don't contain the same number of duplicates" do
      PITCH_CLASS_GROUP.new([C, E, G]).should_not == PITCH_CLASS_GROUP.new([C, C, E, G])
    end

    it "is false if two pitch class sets do not contain the same pitch classes" do
      pitch_class_group.should_not == MTK.PitchClassGroup(C,E)
    end

    it "allows for direct comparison with Arrays" do
      pitch_class_group.should == [C,E,G]
    end
  end

  describe "#=~" do
    it "is true if two pitch class sets contain the same set in the same order" do
      pitch_class_group.should =~ MTK.PitchClassGroup(C,E,G)
    end

    it "is true when all the pitch classes are equal, even with different numbers of duplicates" do
      MTK::Groups::PitchGroup.new([C, E, G]).should =~ MTK::Groups::PitchGroup.new([C, C, E, G])
    end

    it "is true if two pitch class sets are not in the same order" do
      pitch_class_group.should =~ MTK.PitchClassGroup(C,G,E)
    end

    it "is false if two pitch class sets do not contain the same pitch classes" do
      pitch_class_group.should_not =~ MTK.PitchClassGroup(C,E)
    end

    it "allows for direct comparison with Arrays" do
      pitch_class_group.should =~ [C,G,E]
    end
  end

end

describe MTK do

  describe '#PitchClassGroup' do

    it "constructs a PitchClassGroup" do
      PitchClassGroup(C,D).should be_a PITCH_CLASS_GROUP
    end

    it "acts like new for a single Array argument" do
      PitchClassGroup([C,D]).should == PITCH_CLASS_GROUP.new([C,D])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      PitchClassGroup(C,D).should == PITCH_CLASS_GROUP.new([C,D])
    end

    it "handles an Array with elements that can be converted to PitchClasses" do
      PitchClassGroup(['C','D']).should == PITCH_CLASS_GROUP.new([C,D])
    end

    it "handles multiple arguments that can be converted to a PitchClass" do
      PitchClassGroup(:C,:D).should == PITCH_CLASS_GROUP.new([C,D])
    end

    it "handles a single PitchClass" do
      PitchClassGroup(C).should == PITCH_CLASS_GROUP.new([C])
    end

    it "handles single elements that can be converted to a PitchClass" do
      PitchClassGroup('C').should == PITCH_CLASS_GROUP.new([C])
    end

    it "handles a a PitchClassGroup" do
      pitch_set = PITCH_CLASS_GROUP.new([C,D])
      PitchClassGroup(pitch_set).should == PitchClassGroup([C,D])
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchClassGroup({:not => :compatible}) }.should raise_error
    end

  end

end