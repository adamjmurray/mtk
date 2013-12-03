require 'spec_helper'

describe MTK::Patterns::ForEach do

  FOREACH = MTK::Patterns::ForEach

  def for_each_index_var(index)
    MTK::Lang::Variable.new(Variable::FOR_EACH_ELEMENT, :index, index)
  end

  def for_each_random_var()
    MTK::Lang::Variable.new(Variable::FOR_EACH_ELEMENT, :random)
  end

  def for_each_all_var()
    MTK::Lang::Variable.new(Variable::FOR_EACH_ELEMENT, :all)
  end

  def seq(*args)
    MTK::Patterns.Sequence(*args)
  end

  def chain(*args)
    MTK::Patterns.Chain(*args)
  end


  describe "#elements" do
    it "is the array the sequence was constructed with" do
      FOREACH.new([seq(1,2),seq(3,4)]).elements.should == [seq(1,2),seq(3,4)]
    end
  end

  describe "#next" do
    it "enumerates each element in the second pattern for each element in the first, with variable '$' as the first pattern's current element" do
      foreach = FOREACH.new [ seq(C,D,E), seq(for_each_index_var(0),G,A) ]
      vals = []
      9.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [C,G,A,D,G,A,E,G,A]
    end

    it "enumerates the foreach construct with a variable in the middle of the second pattern" do
      foreach = FOREACH.new [ seq(C,D,E), seq(G,for_each_index_var(0),A) ]
      vals = []
      9.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [G,C,A,G,D,A,G,E,A]
    end

    it "enumerates the foreach construct with multiple variables" do
      foreach = FOREACH.new [ seq(C,D,E), seq(G,for_each_index_var(0),A,for_each_index_var(0)) ]
      vals = []
      12.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [G,C,A,C,G,D,A,D,G,E,A,E]
    end

    it "handles 3-level nesting" do
      foreach = FOREACH.new [ seq(C,D), seq(for_each_index_var(0),F), seq(G,for_each_index_var(0)) ]
      vals = []
      8.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [G,C,G,F,G,D,G,F]
    end

    it "handles 4-level nesting" do
      foreach = FOREACH.new [ seq(C,D), seq(for_each_index_var(0),E), seq(F,for_each_index_var(0)), seq(for_each_index_var(0),G) ]
      vals = []
      16.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [F,G,C,G,F,G,E,G,F,G,D,G,F,G,E,G]
    end

    it "evaluates for_each_index_var with value 1 by going back 2 levels in the variables stack" do
      foreach = FOREACH.new [ seq(C,D), seq(E,F), seq(for_each_index_var(1),for_each_index_var(0)) ]
      vals = []
      8.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [C,E,C,F,D,E,D,F]
    end


    it "evaluates the for_each_index_var with value 2 by going back 3 levels in the variables stack" do
      foreach = FOREACH.new [ seq(C,D), seq(E,F), seq(G,A), seq(for_each_index_var(2),for_each_index_var(1),for_each_index_var(0)) ]
      vals = []
      24.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [C,E,G,C,E,A,C,F,G,C,F,A,D,E,G,D,E,A,D,F,G,D,F,A]
    end

    it "evaluates nested variables" do
      # (C4 Bb Ab G)@( (C D C $):(q i i)*4:(mp mf) )
      foreach = FOREACH.new( [seq(G,A), chain(seq(C,D,for_each_index_var(0)),seq(q,e,s))] )
      vals = []
      6.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should == [[C,q],[D,e],[G,s],[C,q],[D,e],[A,s]]
    end

    it "wraps-around the index when it's out of bounds" do
      foreach = FOREACH.new [ seq(C), seq(D), seq(E),
                              seq( for_each_index_var(3), for_each_index_var(4), for_each_index_var(8), for_each_index_var(-1) ) ]
      foreach.next.should == E
      foreach.next.should == D
      foreach.next.should == C
      foreach.next.should == C
    end


    it "evalutes 'random' for each vars by going back to a random level in the for each stack" do
      var = for_each_random_var()
      foreach = FOREACH.new [ seq(C), seq(D), seq(E), # and then a lot of vars to try to avoid random test failures
                              seq(var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,
                                  var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,
                                  var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,
                                  var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var,var) ]
      vals = []
      40.times{ vals << foreach.next }
      vals.should include(C)
      vals.should include(D)
      vals.should include(E)
    end


    it "evalutes 'all' for each vars by returning all for each values in the stack" do
      foreach = FOREACH.new [ seq(C), seq(D), seq(E), seq(for_each_all_var()) ]
      foreach.next.should == [C,D,E]
    end


    it "raises an error when accessing variables before they are defined (start of first sequence)" do
      foreach = FOREACH.new( [ seq(for_each_index_var(0),G,A), seq(C,D,E) ] )
      ->{ foreach.next }.should raise_error
    end

    it "raises an error when accessing variables before they are defined (later in first sequence)" do
      foreach = FOREACH.new( [ seq(G,for_each_index_var(0),A), seq(C) ] )
      foreach.next
      ->{ foreach.next }.should raise_error
    end
  end


  describe "#rewind" do
    it "restarts at the beginning of the sequence" do
      foreach = FOREACH.new [ seq(C,D,E), seq(for_each_index_var(0),G,A) ]
      6.times{ foreach.next }
      foreach.next.should == E
      foreach.rewind
      vals = []
      9.times{ vals << foreach.next }
      lambda{ foreach.next }.should raise_error StopIteration
      vals.should ==  [C,G,A,D,G,A,E,G,A]
    end

    it "returns self, so it can be chained to #next" do
      foreach = FOREACH.new [ seq(C,D,E), seq(for_each_index_var(0),G,A) ]
      first = foreach.next
      foreach.rewind.next.should == first
      foreach.rewind.next.should == first
    end
  end

end


describe MTK::Patterns do

  def seq(*args)
    MTK::Patterns.Sequence(*args)
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