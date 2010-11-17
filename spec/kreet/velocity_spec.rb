require 'spec_helper'
begin # this block seems to be needed to make things work in textmate without breaking rake
  ensure_shared_example_group_name_not_taken "any Value"   
  require 'kreet/value_spec'
rescue 
end

module Kreet

  describe Velocity do
    
    let(:value) { 70.5 }
    subject { Velocity.new(value) }
    let(:lo) { Velocity.new(0.0) }
    let(:hi) { Velocity.new(1.0) }
    let(:subjects) { [lo, hi] }

    it_behaves_like "any Value"
  
  end
end
