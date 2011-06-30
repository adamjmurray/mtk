require 'spec_helper'
require 'mtk/lang/grammar'

describe MTK::Lang::Grammar do

  def parse syntax, root
    MTK::Lang::Grammar.parse(syntax, root)
  end

  describe ".parse" do
    it "should parse pitch classes" do
      parse("Db", :pitch_class).should == Db
    end

    it do
      parse("C4 D4 E4", :pitch_sequence).should == Pattern.PitchSequence(C4, D4, E4)
    end
  end
end