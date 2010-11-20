require 'spec_helper'
module MTK::Frequency

  describe MTK::Frequency::Hertz do

    let(:value) { 440 }
    subject { Hertz.new(value) }

    it_behaves_like "any Scalar"

    describe '#+' do
      
      context 'argument is Numeric' do
        it "is the sum of the value and the argument" do
          for number in [ 44, -44.4, Rational(4/3) ]
            (subject + number).should == subject.value + number
          end
        end
        it "should result in a Hertz" do
          (subject + 2).should be_a Hertz
        end
      end
      
      context 'argument is Semitones' do
        it "is the sum of the value and the argument.to_hz" do
          for number in [ 44, -44.4, Rational(4/3) ]
            arg = Semitones.new(number)
            (subject + arg).should == subject.value + arg.to_hz
          end
        end
        it "should result in a Hertz" do
          ( subject + Semitones.new(2) ).should be_a Hertz
        end
      end
    end
  
  end
end