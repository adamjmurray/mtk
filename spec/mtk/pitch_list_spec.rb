require 'spec_helper'

describe MTK::PitchList do

  let(:pitches) { [C4, D4, E4, D4] }
  let(:pitch_list) { PitchList.new(pitches) }
  let(:c_major) { PitchList.new([C4,E4,G4]) }

  it "is Enumerable" do
    pitch_list.should be_a Enumerable
  end

  describe ".new" do
    it "maintains the pitches collection exactly (preserves order and keeps duplicates)" do
      PitchList.new([C4, E4, G4, E4, B3, C4]).pitches.should == [C4, E4, G4, E4, B3, C4]
    end
  end

  describe '#pitches' do
    it 'is the list of pitches used to construct the scale' do
      pitch_list.pitches.should == pitches
    end

    it "is immutable" do
      lambda { pitch_list.pitches << Db4 }.should raise_error
    end

    it "does not affect the immutabilty of the pitch list used to construct it" do
      list = pitch_list # force construction with the pitches array
      expect { pitches << Db4 }.to change(pitches, :length).by(1)
    end

    it "is not affected by changes to the pitch list used to construct it" do
      pitch_list # force construction before we modify the pitches array
      expect { pitches << Db4 }.to_not change(pitch_list.pitches, :length)
    end

  end

  describe "#to_a" do
    it "is equal to #pitches" do
      pitch_list.to_a.should == pitch_list.pitches
    end

    it "is mutable" do
      (c_major.to_a << Bb4).should == [C4, E4, G4, Bb4]
    end
  end

  describe "#each" do
    it "yields each pitch" do
      ps = []
      pitch_list.each{|p| ps << p }
      ps.should == pitches
    end
  end

  describe "#map" do
    it "returns a PitchList with each Pitch replaced with the results of the block" do
      c_major.map{|p| p + 2}.should == [D4, Gb4, A4]
    end
  end

  describe "#to_pitch_class_list" do
    it "is a PitchClassList" do
      pitch_list.to_pitch_class_list.should be_a PitchClassList
    end

    it "contains all the pitch_classes in this PitchList" do
      pitch_list.to_pitch_class_list.pitch_classes.should == pitch_list.pitch_classes
    end
  end

  describe "#to_pitch_class_set" do
    it "is a PitchClassSet" do
      pitch_list.to_pitch_class_set.should be_a PitchClassSet
    end

    it "contains all the distinct pitch_classes in this PitchList" do
      pitch_list.to_pitch_class_set.pitch_classes.should == pitch_list.pitch_classes.uniq
    end
  end


  describe '#pitch_classes' do
    it 'is the list of pitch classes for the pitches in this list' do
      pitch_list.pitch_classes.should == pitches.map { |p| p.pitch_class }
    end
  end

  describe '#transpose' do
    it 'transposes upward by the given semitones' do
      pitch_list.transpose(12).should == PitchList.new([C5, D5, E5, D5])
    end
  end

  describe '#invert' do
    it 'inverts all pitches around the given center pitch' do
      (pitch_list.invert Gb4).should == PitchList.new([C5, Bb4, Ab4, Bb4])
    end

    it 'inverts all pitches around the first pitch, when no center pitch is given' do
      pitch_list.invert.should == PitchList.new([C4, Bb3, Ab3, Bb3])
    end
  end

  describe '#include?' do
    it 'returns true if the Pitch is in the PitchList' do
      (pitch_list.include? C4).should be_true
    end

    it 'returns false if the Pitch is not in the PitchList' do
      (pitch_list.include? Db4).should be_false
    end
  end

  describe '#==' do
    it "is true when all the pitches are equal" do
      PitchList.new([C4, E4, G4]).should == PitchList.new([Pitch.from_i(60), Pitch.from_i(64), Pitch.from_i(67)])
    end

    it "is false when not all the pitches are equal" do
      PitchList.new([C4, E4, G4]).should_not == PitchList.new([Pitch.from_i(60), Pitch.from_i(65), Pitch.from_i(67)])
    end

    it "is false when if otherwise equal PitchLists don't contain the same number of duplicates" do
      PitchList.new([C4, E4, G4]).should_not == PitchList.new([C4, C4, E4, G4])
    end

    it "is false when if otherwise equal PitchLists aren't in the same order" do
      PitchList.new([C4, E4, G4]).should_not == PitchList.new([C4, G4, E4])
    end

    it "is false when the argument is not compatible" do
      PitchList.new([C4, E4, G4]).should_not == :invalid
    end

    it "can be compared directly to Arrays" do
      PitchList.new([C4, E4, G4]).should == [C4, E4, G4]
    end
  end

  describe "#=~" do
    it "is true when all the pitches are equal" do
      PitchList.new([C4, E4, G4]).should =~ PitchList.new([C4, E4, G4])
    end

    it "is true when all the pitches are equal, even with different numbers of duplicates" do
      PitchList.new([C4, E4, G4]).should =~ PitchList.new([C4, C4, E4, G4])
    end

    it "is true when all the pitches are equal, even in a different order" do
      PitchList.new([C4, E4, G4]).should =~ PitchList.new([C4, G4, E4])
    end

    it "is false when one PitchList contains a Pitch not in the other" do
      PitchList.new([C4, E4, G4]).should_not =~ PitchList.new([C4, E4])
    end

    it "can be compared directly to Arrays" do
      PitchList.new([C4, E4, G4]).should =~ [C4, E4, G4]
    end
  end

  describe '#inversion' do
    it "adds an octave to the chord's pitches starting from the lowest, for each whole number in a postive argument" do
      c_major.inversion(2).should == PitchList.new([G4,C5,E5])
    end

    it "subtracts an octave to the chord's pitches starting fromt he highest, for each whole number in a negative argument" do
      c_major.inversion(-2).should == PitchList.new([E3,G3,C4])
    end

    it "wraps around to the lowest pitch when the argument is bigger than the number of pitches in the chord (positive argument)" do
      c_major.inversion(4).should == PitchList.new([E5,G5,C6])
    end

    it "wraps around to the highest pitch when the magnitude of the argument is bigger than the number of pitches in the chord (negative argument)" do
      c_major.inversion(-4).should == PitchList.new([G2,C3,E3])
    end
  end

  describe "#nearest" do
    it "returns the nearest PitchList where the first Pitch has the given PitchClass" do
      c_major.nearest(F).should == c_major.transpose(5.semitones)
      c_major.nearest(G).should == c_major.transpose(-5.semitones)
    end
  end

  describe "#to_s" do
    it "looks like an array of pitches" do
      c_major.to_s.should == "[C4, E4, G4]"
    end
  end

end

describe MTK do

  describe '#PitchList' do

    it "acts like new for a single Array argument" do
      PitchList([C4,D4]).should == PitchList.new([C4,D4])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      PitchList(C4,D4).should == PitchList.new([C4,D4])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      PitchList(['C4','D4']).should == PitchList.new([C4,D4])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      PitchList(:C4,:D4).should == PitchList.new([C4,D4])
    end

    it "handles a single Pitch" do
      PitchList(C4).should == PitchList.new([C4])
    end

    it "handles single elements that can be converted to a Pitch" do
      PitchList('C4').should == PitchList.new([C4])
    end

    it "handles a PitchList" do
      pitch_list = PitchList.new([C4,D4])
      PitchList(pitch_list).should == [C4,D4]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ PitchList({:not => :compatible}) }.should raise_error
    end

  end

end
