require 'spec_helper'

describe MTK::Lang::RelativeChords do

  describe "I" do
    it "is a major triad at scale index 0" do
      RelativeChords::I.should == RELATIVE_CHORD.new(0, MAJOR_TRIAD)
    end
  end

  describe "i" do
    it "is a minor triad at scale index 0" do
      RelativeChords::i.should == RELATIVE_CHORD.new(0, MINOR_TRIAD)
    end
  end

  describe "II" do
    it "is a major triad at scale index 1" do
      RelativeChords::II.should == RELATIVE_CHORD.new(1, MAJOR_TRIAD)
    end
  end

  describe "ii" do
    it "is a minor triad at scale index 1" do
      RelativeChords::ii.should == RELATIVE_CHORD.new(1, MINOR_TRIAD)
    end
  end

  describe "III" do
    it "is a major triad at scale index 2" do
      RelativeChords::III.should == RELATIVE_CHORD.new(2, MAJOR_TRIAD)
    end
  end

  describe "iii" do
    it "is a minor triad at scale index 2" do
      RelativeChords::iii.should == RELATIVE_CHORD.new(2, MINOR_TRIAD)
    end
  end

  describe "IV" do
    it "is a major triad at scale index 3" do
      RelativeChords::IV.should == RELATIVE_CHORD.new(3, MAJOR_TRIAD)
    end
  end

  describe "iv" do
    it "is a minor triad at scale index 3" do
      RelativeChords::iv.should == RELATIVE_CHORD.new(3, MINOR_TRIAD)
    end
  end

  describe "V" do
    it "is a major triad at scale index 4" do
      RelativeChords::V.should == RELATIVE_CHORD.new(4, MAJOR_TRIAD)
    end
  end

  describe "v" do
    it "is a minor triad at scale index 4" do
      RelativeChords::v.should == RELATIVE_CHORD.new(4, MINOR_TRIAD)
    end
  end

  describe "VI" do
    it "is a major triad at scale index 5" do
      RelativeChords::VI.should == RELATIVE_CHORD.new(5, MAJOR_TRIAD)
    end
  end

  describe "vi" do
    it "is a minor triad at scale index 5" do
      RelativeChords::vi.should == RELATIVE_CHORD.new(5, MINOR_TRIAD)
    end
  end

  describe "VII" do
    it "is a major triad at scale index 6" do
      RelativeChords::VII.should == RELATIVE_CHORD.new(6, MAJOR_TRIAD)
    end
  end

  describe "vii" do
    it "is a minor triad at scale index 6" do
      RelativeChords::vii.should == RELATIVE_CHORD.new(6, MINOR_TRIAD)
    end
  end

  describe "VIII" do
    it "is a major triad at scale index 7" do
      RelativeChords::VIII.should == RELATIVE_CHORD.new(7, MAJOR_TRIAD)
    end
  end

  describe "viii" do
    it "is a minor triad at scale index 7" do
      RelativeChords::viii.should == RELATIVE_CHORD.new(7, MINOR_TRIAD)
    end
  end

  describe "IX" do
    it "is a major triad at scale index 8" do
      RelativeChords::IX.should == RELATIVE_CHORD.new(8, MAJOR_TRIAD)
    end
  end

  describe "ix" do
    it "is a minor triad at scale index 8" do
      RelativeChords::ix.should == RELATIVE_CHORD.new(8, MINOR_TRIAD)
    end
  end

  describe "RELATIVE_CHORDS" do
    it "is all constants defined in the module" do
      RELATIVE_CHORDS.should == [I, i, II, ii, III, iii, IV, iv, V, v, VI, vi, VII, vii, VIII, viii, IX, ix]
    end
  end

  describe "RELATIVE_CHORD_NAMES" do
    it "is the names of all constants defined in the module" do
      RELATIVE_CHORD_NAMES.should == %w[I i II ii III iii IV iv V v VI vi VII vii VIII viii IX ix]
    end
  end

end