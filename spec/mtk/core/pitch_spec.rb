require 'spec_helper'

describe MTK::Core::Pitch do

  let(:middle_c) { Pitch.new(C, 4) }
  let(:lowest) { Pitch.new(C, -1) }
  let(:highest) { Pitch.new(G, 9) }
  let(:middle_c_and_50_cents) { Pitch.new(C, 4, 0.5) }

  describe '.[]' do
    it "constructs and caches a pitch with the given pitch_class and octave" do
      Pitch[C,4].should be_equal Pitch[C,4]
    end

    it "retains the new() method's ability to construct uncached objects" do
      Pitch.new(C,4).should_not be_equal Pitch[C,4]
    end

    it "can handle any type for the first argument that's supported by MTK::Core::PitchClass()" do
      Pitch['C',4].should == Pitch[0, 4]
    end
  end

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
    it("converts 'C-1' to a low c, 5 octaves below middle C") { Pitch.from_s('C-1').should == middle_c - 60 }
    it("converts 'C4+50.0cents' to middle C and 50 cents") { Pitch.from_s('C4+50.0cents').should == middle_c_and_50_cents }

    it "raises an ArgumentError for invalid arguments" do
      lambda{ Pitch.from_s('H4') }.should raise_error ArgumentError
    end
  end

  describe '.from_name' do
    it "acts like .from_s" do
      for name in ['C4', 'c4', 'B#4', 'C-1', 'C4+50.0cents']
        Pitch.from_name(name).should == Pitch.from_s(name)
      end
    end
  end

  describe ".from_h" do
    it "constructs a Pitch from a hash of pitch attributes" do
      Pitch.from_h({:pitch_class => C, :octave => 4, :offset => 0.5}).should == middle_c_and_50_cents
    end
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

  describe "#to_h" do
    it "converts to a Hash" do
      middle_c_and_50_cents.to_h.should == {:pitch_class => C, :octave => 4, :offset => 0.5}
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

  describe '#inspect' do
    it 'includes the pitch name and value' do
      for value in [0, 60, 60.5, 127]
        pitch = Pitch.from_f(value)
        pitch.inspect.should == "#<Pitch: @name=#{pitch.to_s}, @value=#{value}>"
      end
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

  describe "#transpose" do
    it "behaves like #+" do
      middle_c.transpose(2).should == middle_c + 2
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
        middle_c.invert(Pitch.from_i 66).should == Pitch.from_i(72)
      end
    end

    context 'lower center pitch' do
      it 'inverts the pitch around the given center pitch' do
        middle_c.invert(Pitch.from_i 54).should == Pitch.from_i(48)
      end
    end

    it "returns an equal pitch when given itself as an argument" do
      middle_c.invert(middle_c).should == middle_c
    end
  end

  describe "#nearest" do
    it "is the Pitch with the nearest given PitchClass" do
      middle_c.nearest(F).should == F4
      middle_c.nearest(G).should == G3
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

  describe "#clone_with" do
    it "clones the Pitch when given an empty hash" do
      middle_c.clone_with({}).should == middle_c
    end

    it "create a Pitch with the given :pitch_class, and the current Pitch's octave and offset if not provided" do
      pitch2 = middle_c_and_50_cents.clone_with({:pitch_class => middle_c_and_50_cents.pitch_class+1})
      pitch2.pitch_class.should == middle_c_and_50_cents.pitch_class + 1
      pitch2.octave.should == middle_c_and_50_cents.octave
      pitch2.offset.should == middle_c_and_50_cents.offset
    end

    it "create a Pitch with the given :octave, and the current Pitch's pitch_class and offset if not provided" do
      pitch2 = middle_c_and_50_cents.clone_with({:octave => middle_c_and_50_cents.octave+1})
      pitch2.pitch_class.should == middle_c_and_50_cents.pitch_class
      pitch2.octave.should == middle_c_and_50_cents.octave + 1
      pitch2.offset.should == middle_c_and_50_cents.offset
    end

    it "create a Pitch with the given :offset, and the current Pitch's pitch_class and octave if not provided" do
      pitch2 = middle_c_and_50_cents.clone_with({:offset => middle_c_and_50_cents.offset+1})
      pitch2.pitch_class.should == middle_c_and_50_cents.pitch_class
      pitch2.octave.should == middle_c_and_50_cents.octave
      pitch2.offset.should == middle_c_and_50_cents.offset + 1
    end
  end

end

describe MTK do

  describe '#Pitch' do
    it "acts like from_s if the argument is a String" do
      Pitch('D4').should == Pitch.from_s('D4')
    end

    it "acts like from_s if the argument is a Symbol" do
      Pitch(:D4).should == Pitch.from_s(:D4)
    end

    it "acts like from_f if the argument is a Numberic" do
      Pitch(3).should == Pitch.from_f(3)
    end

    it "returns the argument if it's already a PitchClass" do
      Pitch(C4).should be_equal C4
    end

    it "acts like Pitch[] for a 2-element Array" do
      Pitch(C,4).should == Pitch[C,4]
    end

    it "acts like Pitch.new() for a 3-element Array" do
      Pitch(C, 4, 0.5).should == Pitch.new(C, 4, 0.5)
    end

    it "raises an error for Strings it doesn't understand" do
      lambda{ Pitch('H4') }.should raise_error
    end

    it "raises an error for Symbols it doesn't understand" do
      lambda{ Pitch(:H4) }.should raise_error
    end

    it "raises an error for types it doesn't understand" do
      lambda{ Pitch({:not => :compatible}) }.should raise_error
    end
  end

end
