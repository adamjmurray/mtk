require 'spec_helper'

describe Kreet::Sequence do

  subject { Sequence.new(1,2,3) }

  describe '#to_a' do
    it 'converts the sequence to an array' do
      subject.to_a.should == [1,2,3]
    end
  end

end    
