require 'spec_helper'
load_shared_examples_for :scalar

describe MTK::Velocity do

  let(:value) { 70.5 }
  subject { Velocity.new(value) }
  let(:lo) { Velocity.new(0.0) }
  let(:hi) { Velocity.new(1.0) }
  let(:subjects) { [lo, hi] }

  it_behaves_like "any Scalar"

end
