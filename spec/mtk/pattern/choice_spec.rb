require 'spec_helper'
require 'set'

describe MTK::Pattern::Choice do

  let(:elements) { [1,2,3] }
  let(:choice) { Pattern::Choice.new elements }

  describe "#next" do
    it "randomly chooses one of the elements" do
      choosen = Set.new
      100.times do
        element = choice.next
        choosen << element
        elements.should include(element)
      end
      choosen.to_a.sort.should == elements
    end
  end

end
