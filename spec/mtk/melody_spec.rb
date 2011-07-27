require 'spec_helper'

describe MTK::Melody do

  let(:pitches) { [C4, D4, E4, D4] }
  let(:melody) { Melody.new(pitches) }

  it "is Enumerable" do
    melody.should be_a Enumerable
  end

  describe ".new" do
    it "maintains the pitches collection exactly (preserves order and keeps duplicates)" do
      Melody.new([C4, E4, G4, E4, B3, C4]).pitches.should == [C4, E4, G4, E4, B3, C4]
    end
  end
  
  describe ".from_pitch_classes" do
    it "creates a pitch sequence from a list of pitch classes and starting point, selecting the nearest pitch to each pitch class" do
      Melody.from_pitch_classes([C,G,B,Eb,D,C], D3).should == [C3,G2,B2,Eb3,D3,C3]
    end

    it "defaults to a starting point of C4 (middle C)" do
      Melody.from_pitch_classes([C]).should == [C4]
    end

    it "doesn't travel within an octave above or below the starting point by default" do
      Melody.from_pitch_classes([C,F,Bb,D,A,E,B]).should == [C4,F4,Bb4,D4,A3,E3,B3]
    end

    it "allows max distance above or below the starting point to be set via the third argument" do
      Melody.from_pitch_classes([C,F,Bb,D,A,E,B], C4, 6).should == [C4,F4,Bb3,D4,A3,E4,B3]
    end
  end

  describe '#pitches' do
    it 'is the list of pitches used to construct the scale' do
      melody.pitches.should == pitches
    end

    it "is immutable" do
      lambda { melody.pitches << Db4 }.should raise_error
    end

    it "does not affect the immutabilty of the pitch list used to construct it" do
      list = melody # force construction with the pitches array
      expect { pitches << Db4 }.to change(pitches, :length).by(1)
    end

    it "is not affected by changes to the pitch list used to construct it" do
      melody # force construction before we modify the pitches array
      expect { pitches << Db4 }.to_not change(melody.pitches, :length)
    end

  end

  describe "#to_a" do
    it "is equal to #pitches" do
      melody.to_a.should == melody.pitches
    end

    it "is mutable" do
      (melody.to_a << Bb3).should == [C4, D4, E4, D4, Bb3]
    end
  end

  describe "#each" do
    it "yields each pitch" do
      ps = []
      melody.each{|p| ps << p }
      ps.should == pitches
    end
  end

  describe "#map" do
    it "returns a Melody with each Pitch replaced with the results of the block" do
      melody.map{|p| p + 2}.should == [D4, E4, Gb4, E4]
    end
  end

  describe "#to_pitch_class_set" do
    it "is a PitchClassSet" do
      melody.to_pitch_class_set.should be_a PitchClassSet
    end

    it "contains all the distinct pitch_classes in this Melody by default" do
      melody.to_pitch_class_set.pitch_classes.should == melody.pitch_classes.uniq
    end

    it "contains all the pitch_classes (including duplicates) when the argument is false" do
      melody.to_pitch_class_set(false).pitch_classes.should == melody.pitch_classes
    end
  end


  describe '#pitch_classes' do
    it 'is the list of pitch classes for the pitches in this list' do
      melody.pitch_classes.should == pitches.map { |p| p.pitch_class }
    end
  end

  describe '#transpose' do
    it 'transposes upward by the given semitones' do
      melody.transpose(12).should == Melody.new([C5, D5, E5, D5])
    end
  end

  describe '#invert' do
    it 'inverts all pitches around the given center pitch' do
      (melody.invert Gb4).should == Melody.new([C5, Bb4, Ab4, Bb4])
    end

    it 'inverts all pitches around the first pitch, when no center pitch is given' do
      melody.invert.should == Melody.new([C4, Bb3, Ab3, Bb3])
    end
  end

  describe '#include?' do
    it 'returns true if the Pitch is in the Melody' do
      (melody.include? C4).should be_true
    end

    it 'returns false if the Pitch is not in the Melody' do
      (melody.include? Db4).should be_false
    end
  end

  describe '#==' do
    it "is true when all the pitches are equal" do
      Melody.new([C4, E4, G4]).should == Melody.new([Pitch.from_i(60), Pitch.from_i(64), Pitch.from_i(67)])
    end

    it "is false when not all the pitches are equal" do
      Melody.new([C4, E4, G4]).should_not == Melody.new([Pitch.from_i(60), Pitch.from_i(65), Pitch.from_i(67)])
    end

    it "is false when if otherwise equal Melodies don't contain the same number of duplicates" do
      Melody.new([C4, E4, G4]).should_not == Melody.new([C4, C4, E4, G4])
    end

    it "is false when if otherwise equal Melodies aren't in the same order" do
      Melody.new([C4, E4, G4]).should_not == Melody.new([C4, G4, E4])
    end

    it "is false when the argument is not compatible" do
      Melody.new([C4, E4, G4]).should_not == :invalid
    end

    it "can be compared directly to Arrays" do
      Melody.new([C4, E4, G4]).should == [C4, E4, G4]
    end
  end

  describe "#=~" do
    it "is true when all the pitches are equal" do
      Melody.new([C4, E4, G4]).should =~ Melody.new([C4, E4, G4])
    end

    it "is true when all the pitches are equal, even with different numbers of duplicates" do
      Melody.new([C4, E4, G4]).should =~ Melody.new([C4, C4, E4, G4])
    end

    it "is true when all the pitches are equal, even in a different order" do
      Melody.new([C4, E4, G4]).should =~ Melody.new([C4, G4, E4])
    end

    it "is false when one Melody contains a Pitch not in the other" do
      Melody.new([C4, E4, G4]).should_not =~ Melody.new([C4, E4])
    end

    it "can be compared directly to Arrays" do
      Melody.new([C4, E4, G4]).should =~ [C4, E4, G4]
    end
  end

  describe "#to_s" do
    it "looks like an array of pitches" do
      melody.to_s.should == "[C4, D4, E4, D4]"
    end
  end

end

describe MTK do

  describe '#Melody' do

    it "acts like new for a single Array argument" do
      Melody([C4,D4]).should == Melody.new([C4,D4])
    end

    it "acts like new for multiple arguments, by treating them like an Array (splat)" do
      Melody(C4,D4).should == Melody.new([C4,D4])
    end

    it "handles an Array with elements that can be converted to Pitches" do
      Melody(['C4','D4']).should == Melody.new([C4,D4])
    end

    it "handles multiple arguments that can be converted to a Pitch" do
      Melody(:C4,:D4).should == Melody.new([C4,D4])
    end

    it "handles a single Pitch" do
      Melody(C4).should == Melody.new([C4])
    end

    it "handles single elements that can be converted to a Pitch" do
      Melody('C4').should == Melody.new([C4])
    end

    it "handles a Melody" do
      melody = Melody.new([C4,D4])
      Melody(melody).should == [C4,D4]
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Melody({:not => :compatible}) }.should raise_error
    end

  end

end
