require 'spec_helper'

describe MTK::Lang::PseudoConstants do

  module MockConstants
    extend MTK::Lang::PseudoConstants
    define_constant 'constant', :value
  end

  describe "define_constant" do
    it "defines a method method in the module" do
      MockConstants::constant.should == :value
    end

    it "defines a 'module_function'" do
      MockConstants.constant.should == :value
    end
  end

end