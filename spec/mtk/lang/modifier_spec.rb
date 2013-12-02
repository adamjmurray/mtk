require 'spec_helper'

describe MTK::Lang::Modifier do

  describe "#type" do
    it "is the argument the object was constructed with" do
      Modifier.new(:foo).type.should == :foo
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
    it "is true when the argument is a Modifier of the same type" do
      Modifier.new(:foo).should == Modifier.new(:foo)
    end

    it "is false when the argument is a Modifier of a different type" do
      Modifier.new(:foo).should_not == Modifier.new(:bar)
    end

    it "is false when the argument is not a Modifier" do
      Modifier.new(:foo).should_not == :foo
    end
  end

end
