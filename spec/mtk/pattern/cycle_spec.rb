require 'spec_helper'

describe MTK::Pattern::Cycle do

  CYCLE = MTK::Pattern::Cycle

  let(:elements) { [1, 2, 3] }
  let(:cycle) { CYCLE.new elements }

  describe "#next" do
    it "iterates through the list of elements and emits them one at a time" do
      cycle.next.should == elements[0]
      cycle.next.should == elements[1]
      cycle.next.should == elements[2]
    end

    it "starts at the beginning of the list of elements after the end of the list is reached" do
      elements.length.times do
        cycle.next
      end
      cycle.next.should == elements.first
    end

    it "enumerates nested sequences" do
      cycle = CYCLE.new [1, MTK::Pattern.Sequence(2,3), 4]
      nexts = []
      6.times { nexts << cycle.next }
      nexts.should == [1,2,3,4,1,2]
    end
  end

  describe "#rewind" do
    it "restarts the cycle" do
      (elements.length - 1).times do
        cycle.next
      end
      cycle.rewind
      cycle.next.should == elements.first
    end
  end

end
