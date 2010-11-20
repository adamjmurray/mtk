require 'spec_helper'
module Frequency

  describe MTK::Frequency::Kilohertz do
  
    let(:value) { 44.1 }
    subject { Kilohertz.new(value) }

    it_behaves_like "any Scalar"
  
  end
  
end
