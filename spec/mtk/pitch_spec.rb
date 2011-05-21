require 'spec_helper'

describe MTK::Pitch do

  let(:middle_c) { Pitch.new(C, 4) }
  let(:lowest) { Pitch.new(C, -1) }
  let(:highest) { Pitch.new(G, 9) }
  let(:middle_c_and_50_cents) { Pitch.new(C, 4, 0.5) }

  describe '#pitch_class' do
    it "is the pitch class of the pitch" do
      middle_c.pitch_class.should == C
    end
  end

  describe '#octave' do
    it "is the octave of the pitch" do
      middle_c.octave.should == 4
    end
  end

  describe '#offset' do
    it 'is the third argument of the constructor' do
      Pitch.new(C, 4, 0.6).offset.should == 0.6
    end
    it 'defaults to 0' do
      Pitch.new(C, 4).offset.should == 0
    end
  end

  describe '#offset_in_cents' do
    it 'is #offset * 100' do
      middle_c_and_50_cents.offset_in_cents.should == middle_c_and_50_cents.offset * 100
    end
  end

  describe '.from_i' do
    it("converts 60 to middle C") { Pitch.from_i(60).should == middle_c }
    it("converts 0 to C at octave -1") { Pitch.from_i(0).should == lowest }
    it("converts 127 to G at octave 9") { Pitch.from_i(127).should == highest }
  end

  describe '.from_f' do
    it "converts 60.5 to middle C with a 0.5 offset" do
      p = Pitch.from_f(60.5)
      p.pitch_class.should == C
      p.octave.should == 4
      p.offset.should == 0.5
    end
  end

  describe '.from_s' do
    it("converts 'C4' to middle c") { Pitch.from_s('C4').should == middle_c }
    it("converts 'c4' to middle c") { Pitch.from_s('c4').should == middle_c }
    it("converts 'B#4' to middle c") { Pitch.from_s('B#4').should == middle_c }
  end

  describe '#to_f' do
    it "is 60.5 for middle C with a 0.5 offset" do
      middle_c_and_50_cents.to_f.should == 60.5
    end
  end

  describe '#to_i' do
    it("is 60 for middle C") { middle_c.to_i.should == 60 }
    it("is 0 for the C at octave -1") { lowest.to_i.should == 0 }
    it("is 127 for the G at octave 9") { highest.to_i.should == 127 }
    it "rounds to the nearest integer (the nearest semitone value) when there is an offset" do
      Pitch.new(C, 4, 0.4).to_i.should == 60
      Pitch.new(C, 4, 0.5).to_i.should == 61
    end
  end

  describe '#==' do
    it "compares the pitch_class and octave for equality" do
      middle_c.should == Pitch.from_s('C4')
      middle_c.should_not == Pitch.from_s('C3')
      middle_c.should_not == Pitch.from_s('G4')
      middle_c.should_not == Pitch.from_s('G3')
      highest.should == Pitch.from_s('G9')
    end
  end

  describe "#<=>" do
    it "orders pitches based on their underlying float value" do
      ( Pitch.from_f(60) <=> Pitch.from_f(60.5) ).should < 0
    end
  end

  describe '#to_s' do
    it "should be the pitch class name and the octave" do
      for pitch in [middle_c, lowest, highest]
        pitch.to_s.should == pitch.pitch_class.name + pitch.octave.to_s
      end
    end
    it "should include the offset_in_cents when the offset is not 0" do
      middle_c_and_50_cents.to_s.should == "C4+50cents"
    end
    it "rounds to the nearest cent" do
      Pitch.from_f(60.556).to_s.should == "C4+56cents"
    end
  end

  describe '#+' do
    it 'adds the integer value of the argument and #to_i' do
      (middle_c + 2).should == Pitch.from_i(62)
    end

    it 'handles offsets' do
      (middle_c + Pitch.from_f(0.5)).should == Pitch.from_f(60.5)
    end

    it 'returns a new pitch (Pitch is immutabile)' do
      original = Pitch.from_i(60)
      modified = original + 2
      original.should_not == modified
      original.should == Pitch.from_i(60)
    end
  end

  describe '#-' do
    it 'subtracts the integer value of the argument from #to_i' do
      (middle_c - 2).should == Pitch.from_i(58)
    end

    it 'handles offsets' do
      (middle_c - Pitch.from_f(0.5)).should == Pitch.from_f(59.5)
    end

    it 'returns a new pitch (Pitch is immutabile)' do
      original = Pitch.from_i(60)
      modified = original - 2
      original.should_not == modified
      original.should == Pitch.from_i(60)
    end
  end

  describe "#invert" do
    context 'higher center pitch' do
      it 'inverts the pitch around the given center pitch' do
        middle_c.invert(Pitch.from_i(66)).should == Pitch.from_i(72)
      end
    end

    context 'lower center pitch' do
      it 'inverts the pitch around the given center pitch' do
        middle_c.invert(Pitch.from_i(54)).should == Pitch.from_i(48)
      end
    end
  end

  describe '#coerce' do
    it 'allows a Pitch to be added to a Numeric' do
      (2 + middle_c).should == Pitch.from_i(62)
    end

    it 'allows a Pitch to be subtracted from a Numeric' do
      (62 - middle_c).should == Pitch.from_i(2)
    end
  end

end
