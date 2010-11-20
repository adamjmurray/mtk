require 'spec_helper'
module MTK::Intensity

  describe MTK::Intensity::Velocity do

    let(:value) { 70.5 }
    subject { Velocity.new(value) }
    let(:lo) { Velocity.new(0.0) }
    let(:hi) { Velocity.new(1.0) }
    let(:subjects) { [lo, hi] }

    it_behaves_like "any Scalar"

  end
end