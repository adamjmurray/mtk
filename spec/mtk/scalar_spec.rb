require 'spec_helper'

describe MTK::Scalar do

  let(:value) { 9.99 }
  subject  { Scalar.new(value) }

  it_behaves_like "any Scalar"

end
