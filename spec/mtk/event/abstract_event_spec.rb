require 'spec_helper'

describe MTK::Event::AbstractEvent do

  EVENT = Event::AbstractEvent

  let(:type) { :type }
  let(:value) { 0.5 }
  let(:duration) { 2.5 }
  let(:event) { EVENT.new(type, value, duration) }


  describe "#type" do
    it "is the type used to create the Event" do
      event.type.should == type
    end

    it "is a read-only attribute" do
      lambda{ event.type = :anything }.should raise_error
    end
  end

  describe "#value" do
    pending
  end

  describe "#value=" do
    pending
  end

  describe "#duration" do
    it "is the duration used to create the Event" do
      event.duration.should == duration
    end
  end

  describe "#duration=" do
    pending
  end

  describe "#number" do
    pending
  end

  describe "#number=" do
    pending
  end

  describe "#length" do
    it "is always positive (absolute value of the duration used to construct the Event)" do
      EVENT.new(type, value, -duration).length.should == duration
    end
  end

  describe "#rest?" do
    it "is true when the duration used to create the Event was negative" do
      EVENT.new(type, value, -duration).rest?.should be_true
    end

    it "is false when the duration used to create the Event was positive" do
      event.rest?.should be_false
    end
  end

  describe "from_hash" do
    it "constructs an Event using a hash" do
      EVENT.from_hash({ :type => type, :value => value, :duration => duration }).should == event
    end
  end

  describe "#to_hash" do
    it "is a hash containing all the attributes of the Event" do
      event.to_hash.should == { :type => type, :value => value, :duration => duration }
    end
  end

  describe "#duration_in_pulses" do
    it "converts beats to pulses, given pulses_per_beat" do
      EVENT.new(type,0,1).duration_in_pulses(60).should == 60
    end

    it "rounds to the nearest pulse" do
      EVENT.new(type,0,1.5).duration_in_pulses(59).should == 89
    end

    it "is always positive (uses absolute value of the duration used to construct the Event)" do
      EVENT.new(type, value, -1).duration_in_pulses(60).should == 60
    end
  end

  describe "#==" do
    it "is true when the intensities and durations are equal" do
      event.should == EVENT.new(type, value, duration)
    end
    it "is false when the intensities are not equal" do
      event.should_not == EVENT.new(type, value * 0.5, duration)
    end
    it "is false when the durations are not equal" do
      event.should_not == EVENT.new(type, value, duration * 2)
    end
  end

  describe "#to_s" do
    it "has the value and duration to 2-decimal places" do
      EVENT.new(type, 0.454545, 0.789789).to_s.should == "Event(type, 0.45, 0.79)"
    end
    it "includes the #number when not nil" do
      EVENT.new(type, 0.454545, 0.789789, 1).to_s.should == "Event(type[1], 0.45, 0.79)"
    end
  end

  describe "#inspect" do
    it "has the string values of value and duration" do
      EVENT.new(:type, 0.454545, 0.789789).inspect.should == "Event(type, 0.454545, 0.789789)"
    end
    it "includes the #number when not nil" do
      EVENT.new(type, 0.454545, 0.789789, 1).inspect.should == "Event(type[1], 0.454545, 0.789789)"
    end
  end

end
