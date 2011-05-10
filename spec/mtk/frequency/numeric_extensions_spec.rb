require 'spec_helper'

describe Numeric do

  describe '#semitones' do
    it "should return the Numeric" do
      100.semitones.should == 100
    end

    it "should return the Numeric / 100.0" do
      100.cents.should == 1
    end
  end

end

