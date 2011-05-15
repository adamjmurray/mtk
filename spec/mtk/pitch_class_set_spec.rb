require 'spec_helper'

describe MTK::PitchClassSet do

  describe "#normal_form" do
    it "is invariant across reorderings of the pitch classes" do
      PitchClassSet.new([C,E,G]).normal_form.should == [0,4,7]
      PitchClassSet.new([E,C,G]).normal_form.should == [0,4,7]
      PitchClassSet.new([G,E,C]).normal_form.should == [0,4,7]
    end

    it "is invariant across transpositions" do
      PitchClassSet.new([C,Eb,G]).normal_form.should == [0,3,7]
      PitchClassSet.new([Db,E,Ab]).normal_form.should == [0,3,7]
      PitchClassSet.new([Bb,F,Db]).normal_form.should == [0,3,7]
    end
  end

end
