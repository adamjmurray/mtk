require 'spec_helper'

describe MTK::Pattern::AbstractPattern do

  PATTERN = MTK::Pattern::AbstractPattern

  describe "#type" do
    it "is the :type value from the constuctor's options hash" do
      PATTERN.new([], :type => :my_type).type.should == :my_type
    end
  end

end
