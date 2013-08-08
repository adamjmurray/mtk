require 'spec_helper'

describe MTK::Groups::PitchGroup do

  PITCH_GROUP = MTK::Groups::PitchGroup

  let(:pitches) { [C4, D4, E4, D4] }
  let(:pitch_group) { MTK::Groups::PitchGroup.new(pitches) }

  it "is Enumerable" do
    pitch_group.should be_a Enumerable
  end

  describe ".new" do
    it "maintains the pitches collection exactly (preserves order and keeps duplicates)" do
      PITCH_GROUP.new([C4, E4, G4, E4, B3, C4]).pitches.should == [C4, E4, G4, E4, B3, C4]
    end
  end
  
  describe ".from_pitch_classes" do
    it "creates a pitch sequence from a list of pitch classes and starting point, selecting the nearest pitch to each pitch class" do
      PITCH_GROUP.from_pitch_classes([C,G,B,Eb,D,C], D3).should == [C3,G2,B2,Eb3,D3,C3]
    end

    it "defaults to a starting point of C4 (middle C)" do
      PITCH_GROUP.from_pitch_classes([C]).should == [C4]
    end

    it "doesn't travel within an octave above or below the starting point by default" do
      PITCH_GROUP.from_pitch_classes([C,F,Bb,D,A,E,B]).should == [C4,F4,Bb4,D4,A3,E3,B3]
    end

    it "allows max distance above or below the starting point to be set via the third argument" do
      PITCH_GROUP.from_pitch_classes([C,F,Bb,D,A,E,B], C4, 6).should == [C4,F4,Bb3,D4,A3,E4,B3]
    end
  end

  describe '#pitches' do
    it 'is the list of pitches used to construct the scale' do
      pitch_group.pitches.should == pitches
    end

    it "is immutable" do
      lambda { pitch_group.pitches << Db4 }.should raise_error
    end

    it "does not affect the immutabilty of the pitch list used to construct it" do
      list = pitch_group # force construction with the pitches array
      expect { pitches << Db4 }.to change(pitches, :length).by(1)
    end

    it "is not affected by changes to the pitch list used to construct it" do
      pitch_group # force construction before we modify the pitches array
      expect { pitches << Db4 }.to_not change(pitch_group.pitches, :length)
    end

  end

  describe "#to_a" do
    it "is equal to #pitches" do
      pitch_group.to_a.should == pitch_group.pitches
    end

    it "is mutable" do
      (pitch_group.to_a << Bb3).should == [C4, D4, E4, D4, Bb3]
    end
  end

  describe "#each" do
    it "yields each pitch" do
      ps = []
      pitch_group.each{|p| ps << p }
      ps.should == pitches
    end
  end

  describe "#map" do
    it "returns a PITCH_GROUP with each Pitch replaced with the results of the block" do
      pitch_group.map{|p| p + 2}.should == [D4, E4, Gb4, E4]
    end
  end

  describe "#to_pitch_class_set" do
    it "is a PitchClassSet" do
      pitch_group.to_pitch_class_set.should be_a MTK::Groups::PitchClassSet
    end

    it "contains only the distinct pitch_classes in this PitchGroup" do
      pitch_group.to_pitch_class_set.pitch_classes.should == pitch_group.pitch_classes.uniq
    end

  end


  describe '#pitch_classes' do
    it 'is the list of pitch classes for the pitches in this list' do
      pitch_group.pitch_classes.should == pitches.map { |p| p.pitch_class }
    end
  end

  describe '#transpose' do
    it 'transposes upward by the given semitones' do
      pitch_group.transpose(12).should == PITCH_GROUP.new([C5, D5, E5, D5])
    end
  end

  describe '#invert' do
    it 'inverts all pitches around the given center pitch' do
      (pitch_group.invert Gb4).should == PITCH_GROUP.new([C5, Bb4, Ab4, Bb4])
    end

    it 'inverts all pitches around the first pitch, when no center pitch is given' do
      pitch_group.invert.should == PITCH_GROUP.new([C4, Bb3, Ab3, Bb3])
    end
  end


  describe '#arpeggiate' do

    it 'returns the pitch at the given index' do
      pitch_group.arpeggiate(2).should == E4
    end

    it 'adds an octave for each time the index "wraps around" the pitch group' do
      pitch_group.arpeggiate(8).should == C6
    end

    it 'subtracts an octave for each time the index "wraps around" the pitch group in the negative direction' do
      pitch_group.arpeggiate(-6).should == E2
    end

    it 'returns nil when the PitchGroup is empty' do
      PITCH_GROUP.new([]).arpeggiate(1).should be_nil
    end

  end


  describe '#include?' do
    it 'returns true if the Pitch is in the PITCH_GROUP' do
      (pitch_group.include? C4).should be_true
    end

    it 'returns false if the Pitch is not in the PITCH_GROUP' do
      (pitch_group.include? Db4).should be_false
    end
  end

  describe '#==' do
    it "is true when all the pitches are equal" do
      PITCH_GROUP.new([C4, E4, G4]).should == PITCH_GROUP.new([Pitch.from_i(60), Pitch.from_i(64), Pitch.from_i(67)])
    end

    it "is false when not all the pitches are equal" do
      PITCH_GROUP.new([C4, E4, G4]).should_not == PITCH_GROUP.new([Pitch.from_i(60), Pitch.from_i(65), Pitch.from_i(67)])
    end

    it "is false when if otherwise equal Melodies don't contain the same number of duplicates" do
      PITCH_GROUP.new([C4, E4, G4]).should_not == PITCH_GROUP.new([C4, C4, E4, G4])
    end

    it "is false when if otherwise equal Melodies aren't in the same order" do
      PITCH_GROUP.new([C4, E4, G4]).should_not == PITCH_GROUP.new([C4, G4, E4])
    end

    it "is false when the argument is not compatible" do
      PITCH_GROUP.new([C4, E4, G4]).should_not == :invalid
    end

    it "can be compared directly to Arrays" do
      PITCH_GROUP.new([C4, E4, G4]).should == [C4, E4, G4]
    end
  end

  describe "#=~" do
    it "is true when all the pitches are equal" do
      PITCH_GROUP.new([C4, E4, G4]).should =~ PITCH_GROUP.new([C4, E4, G4])
    end

    it "is true when all the pitches are equal, even with different numbers of duplicates" do
      PITCH_GROUP.new([C4, E4, G4]).should =~ PITCH_GROUP.new([C4, C4, E4, G4])
    end

    it "is true when all the pitches are equal, even in a different order" do
      PITCH_GROUP.new([C4, E4, G4]).should =~ PITCH_GROUP.new([C4, G4, E4])
    end

    it "is false when one PITCH_GROUP contains a Pitch not in the other" do
      PITCH_GROUP.new([C4, E4, G4]).should_not =~ PITCH_GROUP.new([C4, E4])
    end

    it "can be compared directly to Arrays" do
      PITCH_GROUP.new([C4, E4, G4]).should =~ [C4, E4, G4]
    end
  end

  describe "#to_s" do
    it "looks like an array of pitches" do
      pitch_group.to_s.should == "[C4, D4, E4, D4]"
    end
  end

end

describe MTK do

  describe '#PitchGroup' do

    it "acts like new for a single Array argument" do
      PitchGroup([C4,D4]).should == MTK::Groups::PitchGroup.new([C4,D4])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      PitchGroup(C4,D4).should == MTK::Groups::PitchGroup.new([C4,D4])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      PitchGroup(['C4','D4']).should == MTK::Groups::PitchGroup.new([C4,D4])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      PitchGroup(:C4,:D4).should == MTK::Groups::PitchGroup.new([C4,D4])
    end

    it "handles a single Pitch" do
      PitchGroup(C4).should == MTK::Groups::PitchGroup.new([C4])
    end

    it "handles single elements that can be converted to a Pitch" do
      PitchGroup('C4').should == MTK::Groups::PitchGroup.new([C4])
    end

    it "handles a PitchGroup" do
      pitch_group = MTK::Groups::PitchGroup.new([C4,D4])
      PitchGroup(pitch_group).should == [C4,D4]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchGroup({:not => :compatible}) }.should raise_error
    end

  end

end
