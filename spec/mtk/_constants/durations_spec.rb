require 'spec_helper'

describe MTK::Durations do

  describe 'w' do
    it 'is 4 beats' do
      w.should == 4
    end
    it 'is available via a module property and via mixin' do
      Durations::w.should == w
    end
  end

  describe 'h' do
    it 'is 2 beats' do
      h.should == 2
    end
    it 'is available via a module property and via mixin' do
      Durations::h.should == h
    end
  end

  describe 'q' do
    it 'is 1 beat' do
      q.round.should == 1
    end
    it 'is available via a module property and via mixin' do
      Durations::q.should == q
    end
  end

  describe 'e' do
    it 'is 1/2 of a beat' do
      e.should == 1.0/2
    end
    it 'is available via a module property and via mixin' do
      Durations::e.should == e
    end
  end

  describe 's' do
    it 'is 1/4 of a beat' do
      s.should == 1.0/4
    end
    it 'is available via a module property and via mixin' do
      Durations::s.should == s
    end
  end

  describe 'r' do
    it 'is 1/8 of a beat' do
      r.should == 1.0/8
    end
    it 'is available via a module property and via mixin' do
      Durations::r.should == r
    end
  end

  describe 'x' do
    it 'is 1/16 of a beat' do
      x.should == 1.0/16
    end
    it 'is available via a module property and via mixin' do
      Durations::x.should == x
    end
  end

  describe "DURATIONS" do
    it "contains all Durations pseudo-constants" do
      Durations::DURATIONS.should =~ [w, h, q, e, s, r, x]
    end

    it "is immutable" do
      lambda{ Durations::DURATIONS << :something }.should raise_error
    end
  end

  describe "DURATION_NAMES" do
    it "contains all Durations pseudo-constants names as strings" do
      Durations::DURATION_NAMES.should =~ ['w', 'h', 'q', 'e', 's', 'r', 'x']
    end

    it "is immutable" do
      lambda{ Durations::DURATION_NAMES << :something }.should raise_error
    end
  end

  describe ".[]" do
    it "looks up the constant by name" do
      for duration in Durations::DURATION_NAMES
        Durations[duration].should == Durations.send(duration)
      end
    end

    it "supports a '.' suffix, which multiples the value by 1.5" do
      for duration in Durations::DURATION_NAMES
        Durations["#{duration}."].should == Durations.send(duration) * 1.5
      end
    end

    it "supports a 't' suffix, which multiples the value by 2/3" do
      for duration in Durations::DURATION_NAMES
        Durations["#{duration}t"].should == Durations.send(duration) * 2/3.0
      end
    end

    it "supports '.' and 't' suffixes in any combination" do
      for duration in Durations::DURATION_NAMES
        Durations["#{duration}.t"].should == Durations.send(duration) * 1.5 * 2/3.0
        Durations["#{duration}t."].should == Durations.send(duration) * 1.5 * 2/3.0
        Durations["#{duration}.."].should == Durations.send(duration) * 1.5 * 1.5
        Durations["#{duration}..t.t."].should == Durations.send(duration) * 1.5**4 * (2/3.0)**2
      end
    end

    it "returns nil for arguments it doesn't understand" do
      Durations[:invalid].should be_nil
    end
  end

end

