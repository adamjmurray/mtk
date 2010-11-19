require 'spec_helper'

describe MTK::Scalar do

  let(:value) { 9.99 }
  subject  { Scalar.new(value) }
  let(:lo) { Scalar.new(0.0) }
  let(:hi) { Scalar.new(1.0) }
  let(:subjects) { [lo, hi] }

  it_behaves_like "any Scalar"

end
