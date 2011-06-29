require 'spec_helper'
require 'mtk/lang/grammar'

describe MTK::Lang::Grammar do

  GRAMMAR = MTK::Lang::Grammar

  describe ".parse" do
    it "should parse pitch classes" do
      GRAMMAR.parse("Db", :pitch_class).should == Db
    end
  end
end