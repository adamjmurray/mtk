require 'spec_helper'
module Frequency

describe MTK::Frequency::Hertz do
  
  let(:value) { 440 }
  subject { Hertz.new(value) }
  let(:lo) { Hertz.new(0.0) }
  let(:hi) { Hertz.new(1.0) }
  let(:subjects) { [lo, hi] }
  subject { Hertz.new(440) }
  
  it_behaves_like "any Scalar"
  
  describe '#+' do
    it "can add to Numeric objects" do
      for number in [ 44, -44.4, Rational(4/3) ]
        (subject + number).should == subject.to_f + number
      end
    end
    it "should result in a Hertz" do
      (subject + 2).should be_a Hertz
    end
  end
  
  it "is able to be added to numbers" do
    (44 + subject).should == 484
  end
  
end
end