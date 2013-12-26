require 'spec_helper'

describe MTK::Lang::Modifier do

  describe "#type" do
    it "is the argument the object was constructed with" do
      Modifier.new(:foo).type.should == :foo
    end
  end

  describe "#locked?" do
    it "is true if the type is :octave_lock" do
      Modifier.new(:octave_lock).locked?.should be_true
    end

    it "is false for other types" do
      for type in [:octave, :skip, :force_rest]
        Modifier.new(type).locked?.should be_false
      end
    end
  end

  describe "#octave?" do
    it "is true if the type is :octave" do
      Modifier.new(:octave).octave?.should be_true
    end

    it "is true if the type is :octave_lock" do
      Modifier.new(:octave_lock).octave?.should be_true
    end

    it "is false for other types" do
      for type in [:skip, :force_rest]
        Modifier.new(type).octave?.should be_false
      end
    end
  end

  describe "#force_rest?" do
    it "is true when the Modifier was constructed with the :force_rest type" do
      Modifier.new(:force_rest).force_rest?.should be_true
    end

    it "is false otherwise" do
      Modifier.new(:foo).force_rest?.should be_false
    end
  end

  describe "#==" do
    it "is true when the argument is a Modifier of the same type and both have nil values" do
      Modifier.new(:foo).should == Modifier.new(:foo)
    end

    it "is true when the argument is a Modifier of the same type with values" do
      Modifier.new(:foo, 1).should == Modifier.new(:foo, 1)
    end

    it "is false when the argument is a Modifier of a different type" do
      Modifier.new(:foo).should_not == Modifier.new(:bar)
    end

    it "is false when the argument is a Modifier of a different value" do
      Modifier.new(:foo, 1).should_not == Modifier.new(:foo)
      Modifier.new(:foo).should_not == Modifier.new(:foo, 1)
      Modifier.new(:foo, 1).should_not == Modifier.new(:foo, 2)
    end

    it "is false when the argument is not a Modifier" do
      Modifier.new(:foo).should_not == :foo
    end
  end

end
