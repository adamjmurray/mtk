require 'spec_helper'
require 'mtk/lang/grammar'

describe MTK::Lang::Grammar do

  def parse syntax, root
    MTK::Lang::Grammar.parse(syntax, root)
  end

  describe ".parse" do

    it "should parse pitch sequences" do
      parse("C4 D4 E4", :pitch_sequence).should == Pattern.PitchSequence(C4, D4, E4)
    end

    it "should parse pitch classes" do
      for pitch_class_name in PitchClass::VALID_NAMES
        parse(pitch_class_name, :pitch_class).should == PitchClass[pitch_class_name]
      end
    end

    it "should parse ints as numbers" do
      parse("123", :number).should == 123
    end

    it "should parse floats as numbers" do
      parse("1.23", :number).should == 1.23
    end

    it "should parse floats" do
      parse("1.23", :float).should == 1.23
    end

    it "should parse negative floats" do
      parse("-1.23", :float).should == -1.23
    end

    it "should parse ints" do
      parse("123", :int).should == 123
    end

    it "should parse negative ints" do
      parse("-123", :int).should == -123
    end

    it "should parse negative ints" do
      parse("-123", :int).should == -123
    end

    it "should give nil as the value for whitespace" do
      parse(" \t\n", :space).should == nil
    end
  end
end