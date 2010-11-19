shared_examples_for "any Scalar" do

  it 'should have Comparable methods' do
    lo.should      < hi
    hi.should_not  > hi
    lo.should     <= lo
    lo.should     <= hi
    hi.should_not <= lo
    lo.should     >= lo
    hi.should     >= lo
    lo.should_not >= hi
    hi.should      > lo
    lo.should_not  > hi
  end

  describe '#value' do
    it 'is the value the object was constructed with' do
      subject.value.should == value
    end
  end

  describe '#to_f' do
    it 'is the value as a float' do
      val = Rational(3,5)
      subject.class.new( val ).to_f.should == val.to_f
    end
  end

  describe '#to_i' do
    it 'is the value rounded to the nearest int' do
      subject.to_i.should == value.round
    end
  end

  describe '#==' do
    it 'is true if the values are equal' do
      lo.should == lo
      hi.should == hi
    end
    it 'is true if the value is equal to a Numeric argument' do
      lo.should == lo.value
      hi.should == hi.value
    end
    it 'is false if the values are not equal' do
      lo.should_not == hi
      hi.should_not == lo
    end
    it 'is false if the types are not compatible' do
      lo.should_not == nil
      lo.should_not == lo.value.to_s
    end
  end

  describe '#<=>' do
    it "is the receiver's value <=> the argument's value" do
      for s1 in subjects
        for s2 in subjects
          ( s1 <=> s2 ).should == ( s1.value <=> s2.value )
        end
      end
    end
  end 

  describe '#+' do
    it 'produces a Value with the value of the sum' do
      ( subject + 3 ).value.should == subject.value + 3
    end    
    it 'produces a type of Value with the same class as the receiver' do
      (subject + 1.5).should be_a subject.class
    end
  end

  describe '#-' do
    it 'produces a Value with the value of the difference' do
      ( subject - 3 ).value.should == subject.value - 3
    end    
    it 'produces a type of Value with the same class as the receiver' do
      (subject - 1.5).should be_a subject.class
    end      
  end

  describe '#*' do
    it 'produces a Value with the value of the product' do
      ( subject * 3 ).value.should == subject.value * 3
    end
    it 'produces a type of Value with the same class as the receiver' do
      (subject * 1.5).should be_a subject.class
    end            
  end

  describe '#/' do
    it 'produces a Value with the value of the product' do
      ( subject / 3 ).value.should == subject.value / 3
    end
    it 'produces a type of Value with the same class as the receiver' do
      (subject / 1.5).should be_a subject.class
    end            
  end

  describe '%/' do
    it 'produces a Value with the value of the remainder' do
      ( subject % 3 ).value.should == subject.value % 3
    end
    it 'produces a type of Value with the same class as the receiver' do
      (subject % 1.5).should be_a subject.class
    end            
  end

end