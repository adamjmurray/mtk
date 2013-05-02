require 'spec_helper'

describe MTK::Constants::Durations do

  describe 'w' do
    it 'is 4 beats' do
      w.value.should == 4
    end
    it 'is available via a module property and via mixin' do
      Durations::w.should == w
    end
  end

  describe 'h' do
    it 'is 2 beats' do
      h.value.should == 2
    end
    it 'is available via a module property and via mixin' do
      Durations::h.should == h
    end
  end

  describe 'q' do
    it 'is 1 beat' do
      q.value.should == 1
    end
    it 'is available via a module property and via mixin' do
      Durations::q.should == q
    end
  end

  describe 'i' do
    it 'is 1/2 of a beat' do
      i.value.should == 1.0/2
    end
    it 'is available via a module property and via mixin' do
      Durations::i.should == i
    end
  end

  describe 's' do
    it 'is 1/4 of a beat' do
      s.value.should == 1.0/4
    end
    it 'is available via a module property and via mixin' do
      Durations::s.should == s
    end
  end

  describe 'r' do
    it 'is 1/8 of a beat' do
      r.value.should == 1.0/8
    end
    it 'is available via a module property and via mixin' do
      Durations::r.should == r
    end
  end

  describe 'x' do
    it 'is 1/16 of a beat' do
      x.value.should == 1.0/16
    end
    it 'is available via a module property and via mixin' do
      Durations::x.should == x
    end
  end

  describe "DURATIONS" do
    it "contains all Durations pseudo-constants" do
      Durations::DURATIONS.should =~ [w, h, q, i, s, r, x]
    end

    it "is immutable" do
      lambda{ Durations::DURATIONS << :something }.should raise_error
    end
  end

  describe "DURATION_NAMES" do
    it "contains all Durations pseudo-constants names as strings" do
      Durations::DURATION_NAMES.should =~ ['w', 'h', 'q', 'i', 's', 'r', 'x']
    end

    it "is immutable" do
      lambda{ Durations::DURATION_NAMES << :something }.should raise_error
    end
  end

end

