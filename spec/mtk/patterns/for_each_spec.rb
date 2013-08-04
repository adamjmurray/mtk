require 'spec_helper'

describe MTK::Patterns::ForEach do

  FOREACH = ::MTK::Patterns::ForEach

  def var(name)
    ::MTK::Lang::Variable.new(name)
  end

  def seq(*args)
    ::MTK::Patterns.Sequence(*args)
  end

  def chain(*args)
    ::MTK::Patterns.Chain(*args)
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

    it "evaluates nested variables" do
      # (C4 Bb Ab G)@( (C D C $):(q i i)*4:(mp mf) )
      foreach = FOREACH.new( [seq(G,A), chain(seq(C,D,var('$')),seq(q,e,s))] )
      vals = []
      6.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should == [[C,q],[D,e],[G,s],[C,q],[D,e],[A,s]]
    end

  end



  describe "#rewind" do
    it "restarts at the beginning of the sequence" do
      foreach = FOREACH.new [ seq(C,D,E), seq(var('$'),G,A) ]
      6.times{ foreach.next }
      foreach.next.should == E
      foreach.rewind
      vals = []
      9.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [C,G,A,D,G,A,E,G,A]
    end

    it "returns self, so it can be chained to #next" do
      foreach = FOREACH.new [ seq(C,D,E), seq(var('$'),G,A) ]
      first = foreach.next
      foreach.rewind.next.should == first
      foreach.rewind.next.should == first
    end
  end

end


describe MTK::Patterns do

  def seq(*args)
    ::MTK::Patterns.Sequence(*args)
  end

  describe "#ForEach" do
    it "creates a Sequence" do
      MTK::Patterns.ForEach(seq(1,2),seq(3,4)).should be_a MTK::Patterns::ForEach
    end

    it "sets #elements from the varargs" do
      MTK::Patterns.ForEach(seq(1,2),seq(3,4)).elements.should == [seq(1,2),seq(3,4)]
    end
  end

end