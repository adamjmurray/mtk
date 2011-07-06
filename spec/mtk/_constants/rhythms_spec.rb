require 'spec_helper'

describe MTK::Rhythms do

  describe 'w' do
    it 'is 4 beats' do
      w.should == 4
    end
    it 'is available via a module property and via mixin' do
      Rhythms::w.should == w
    end
  end

  describe 'h' do
    it 'is 2 beats' do
      h.should == 2
    end
    it 'is available via a module property and via mixin' do
      Rhythms::h.should == h
    end
  end

  describe 'q' do
    it 'is 1 beat' do
      q.round.should == 1
    end
    it 'is available via a module property and via mixin' do
      Rhythms::q.should == q
    end
  end

  describe 'e' do
    it 'is 1/2 of a beat' do
      e.should == 1.0/2
    end
    it 'is available via a module property and via mixin' do
      Rhythms::e.should == e
    end
  end

  describe 's' do
    it 'is 1/4 of a beat' do
      s.should == 1.0/4
    end
    it 'is available via a module property and via mixin' do
      Rhythms::s.should == s
    end
  end

  describe 'r' do
    it 'is 1/8 of a beat' do
      r.should == 1.0/8
    end
    it 'is available via a module property and via mixin' do
      Rhythms::r.should == r
    end
  end

  describe 'x' do
    it 'is 1/16 of a beat' do
      x.should == 1.0/16
    end
    it 'is available via a module property and via mixin' do
      Rhythms::x.should == x
    end
  end

  describe ".[]" do
    it "looks up the constant by name" do
      Rhythms['w'].should == w
      Rhythms['h'].should == h
      Rhythms['q'].should == q
      Rhythms['e'].should == e
      Rhythms['s'].should == s
      Rhythms['r'].should == r
      Rhythms['x'].should == x
    end
  end

  describe "RHYTHMS" do
    it "contains all Rhythms pseudo-constants" do
      Rhythms::RHYTHMS.should =~ [w, h, q, e, s, r, x]
    end

    it "is immutable" do
      lambda{ Rhythms::RHYTHMS << :something }.should raise_error
    end
  end

end

