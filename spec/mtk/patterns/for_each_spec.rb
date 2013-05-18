require 'spec_helper'

describe MTK::Patterns::ForEach do

  FOREACH = ::MTK::Patterns::ForEach

  def var(name)
    ::MTK::Variable.new(name)
  end

  def seq(*args)
    ::MTK::Patterns.Sequence(*args)
  end


  describe "#elements" do
    it "is the array the sequence was constructed with" do
      FOREACH.new([seq(1,2),seq(3,4)]).elements.should == [seq(1,2),seq(3,4)]
    end
  end

  describe "#next" do
    it "enumerates each element in the second pattern for each element in the first, with variable '$' as the first pattern's current element" do
      foreach = FOREACH.new [ seq(C,D,E), seq(var('$'),G,A) ]
      vals = []
      9.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [C,G,A,D,G,A,E,G,A]
    end

    it "enumerates the foreach construct with a variable in the middle of the second pattern" do
      foreach = FOREACH.new [ seq(C,D,E), seq(G,var('$'),A) ]
      vals = []
      9.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [G,C,A,G,D,A,G,E,A]
    end

    it "enumerates the foreach construct with multiple variables" do
      foreach = FOREACH.new [ seq(C,D,E), seq(G,var('$'),A,var('$')) ]
      vals = []
      12.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [G,C,A,C,G,D,A,D,G,E,A,E]
    end

    it "handles 3-level nesting" do
      foreach = FOREACH.new [ seq(C,D), seq(var('$'),F), seq(G,var('$')) ]
      vals = []
      8.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [G,C,G,F,G,D,G,F]
    end

    it "handles 4-level nesting" do
      foreach = FOREACH.new [ seq(C,D), seq(var('$'),E), seq(F,var('$')), seq(var('$'),G) ]
      vals = []
      16.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [F,G,C,G,F,G,E,G,F,G,D,G,F,G,E,G]
    end

    it "evaluates the '$$' var by going back 2 levels in the variables stack" do
      foreach = FOREACH.new [ seq(C,D), seq(E,F), seq(var('$$'),var('$')) ]
      vals = []
      8.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [C,E,C,F,D,E,D,F]
    end


    it "evaluates the '$$$' var by going back 3 levels in the variables stack" do
      foreach = FOREACH.new [ seq(C,D), seq(E,F), seq(G,A), seq(var('$$$'),var('$$'),var('$')) ]
      vals = []
      24.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [C,E,G,C,E,A,C,F,G,C,F,A,D,E,G,D,E,A,D,F,G,D,F,A]
    end

    # TODO: update the rest of these to test ForEach
    #
    #it "raises StopIteration when the end of the Sequence is reached" do
    #  elements.length.times{ sequence.next }
    #  lambda{ sequence.next }.should raise_error(StopIteration)
    #end
    #
    #it "should automatically break out of Kernel#loop" do
    #  nexts = []
    #  loop do # loop rescues StopIteration and exits the loop
    #    nexts << sequence.next
    #  end
    #  nexts.should == elements
    #end
    #
    #it "enumerates the elements in sub-sequences" do
    #  sub_sequence = SEQUENCE.new [2,3]
    #  sequence = SEQUENCE.new [1,sub_sequence,4]
    #  nexts = []
    #  loop { nexts << sequence.next }
    #  nexts.should == [1,2,3,4]
    #end
    #
    #it "skips over empty sub-sequences" do
    #  sub_sequence = SEQUENCE.new []
    #  sequence = SEQUENCE.new [1,sub_sequence,4]
    #  nexts = []
    #  loop { nexts << sequence.next }
    #  nexts.should == [1,4]
    #end

  end


  #
  #describe "#rewind" do
  #  it "restarts at the beginning of the sequence" do
  #    loop { sequence.next }
  #    sequence.rewind
  #    sequence.next.should == elements.first
  #  end
  #
  #  it "returns self, so it can be chained to #next" do
  #    first = sequence.next
  #    sequence.rewind.next.should == first
  #  end
  #
  #  it "causes sub-sequences to start from the beginning when encountered again after #rewind" do
  #    sub_sequence = SEQUENCE.new [2,3]
  #    sequence = SEQUENCE.new [1,sub_sequence,4]
  #    loop { sequence.next }
  #    sequence.rewind
  #    nexts = []
  #    loop { nexts << sequence.next }
  #    nexts.should == [1,2,3,4]
  #  end
  #end

end


#describe MTK::Patterns do
#
#  describe "#Sequence" do
#    it "creates a Sequence" do
#      MTK::Patterns.Sequence(1,2,3).should be_a MTK::Patterns::Sequence
#    end
#
#    it "sets #elements from the varargs" do
#      MTK::Patterns.Sequence(1,2,3).elements.should == [1,2,3]
#    end
#  end
#
#  describe "#PitchSequence" do
#    it "creates a Sequence" do
#      MTK::Patterns.PitchSequence(1,2,3).should be_a MTK::Patterns::Sequence
#    end
#
#    it "sets #elements from the varargs" do
#      MTK::Patterns.PitchSequence(1,2,3).elements.should == [Pitch(1),Pitch(2),Pitch(3)]
#    end
#  end
#
#  describe "#IntensitySequence" do
#    it "creates a Sequence" do
#      MTK::Patterns.IntensitySequence(1,2,3).should be_a MTK::Patterns::Sequence
#    end
#
#    it "sets #elements from the varargs" do
#      MTK::Patterns.IntensitySequence(1,2,3).elements.should == [Intensity(1),Intensity(2),Intensity(3)]
#    end
#  end
#
#  describe "#DurationSequence" do
#    it "creates a Sequence" do
#      MTK::Patterns.DurationSequence(1,2,3).should be_a MTK::Patterns::Sequence
#    end
#
#    it "sets #elements from the varargs" do
#      MTK::Patterns.DurationSequence(1,2,3).elements.should == [Duration(1),Duration(2),Duration(3)]
#    end
#  end
#
#end