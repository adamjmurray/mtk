require 'spec_helper'

describe MTK::Events::Event do

  EVENT = MTK::Events::Event

  let(:type) { :type }
  let(:duration) { 2.5 }
  let(:options) { {:number => 1, :value => 0.5, :duration => duration, :channel => 0} }
  let(:event) { EVENT.new type, options }
  let(:hash) { options.merge({:type => type}) }


  describe "#type" do
    it "is the first agument passed to AbstractEvent.new" do
      event.type.should == type
    end

    it "is a read-only attribute" do
      lambda{ event.type = :anything }.should raise_error
    end
  end

  describe "#value" do
    it "is the value of the :value key in the options hash passed to AbstractEvent.new" do
      event.value.should == options[:value]
    end

    it "defaults to nil" do
      EVENT.new(type).value.should be_nil
    end
  end

  describe "#value=" do
    it "sets #value" do
      event.value = 42
      event.value.should == 42
    end
  end

  describe "#duration" do
    it "is the value of the :duration key in the options hash passed to AbstractEvent.new" do
      event.duration.should == options[:duration]
    end

    it "defaults to 0" do
      EVENT.new(type).duration.should == 0
    end
  end

  describe "#duration=" do
    it "sets #duration" do
      event.duration = 42
      event.duration.should == 42
    end
  end

  describe "#number" do
    it "is the value of the :number key in the options hash passed to AbstractEvent.new" do
      event.number.should == options[:number]
    end

    it "defaults to nil" do
      EVENT.new(type).number.should be_nil
    end
  end

  describe "#number=" do
    it "sets #number" do
      event.number = 42
      event.number.should == 42
    end
  end

  describe "#channel" do
    it "is the value of the :channel key in the options hash passed to AbstractEvent.new" do
      event.channel.should == options[:channel]
    end

    it "defaults to nil" do
      EVENT.new(type).channel.should be_nil
    end
  end

  describe "#channel=" do
    it "sets #channel" do
      event.channel = 42
      event.channel.should == 42
    end
  end

  describe "#midi_value" do
    it "is the @value * 127, rounded to the nearest integer" do
      event.midi_value.should == (options[:value]*127).round
    end

    it "defaults to 0 when the @value is nil" do
      EVENT.new(type).midi_value.should == 0
    end

    it "enforces a minimum of 0" do
      event.value = -2
      event.midi_value.should == 0
    end

    it "enforces a maximum of 127" do
      event.value = 2
      event.midi_value.should == 127
    end
  end

  describe "#midi_value=" do
    it "sets #value to the argument/127.0" do
      event.midi_value = 100
      event.value.should == 100/127.0
    end
  end

  describe "#length" do
    it "is the absolute value of duration" do
      event.duration = -duration
      event.length.should == duration
    end

    it "is 0 if the #duration is nil" do
      event.duration = nil
      event.length.should == 0
    end
  end

  describe "#rest?" do
    it "is true when the duration is negative" do
      event.duration = -duration
      event.rest?.should be_true
    end

    it "is false when the duration is positive" do
      event.rest?.should be_false
    end
  end

  describe "#instantaneous?" do
    it "is true when the duration is 0" do
      event.duration = 0
      event.instantaneous?.should be_true
    end

    it "is true when the duration is nil" do
      event.duration = nil
      event.instantaneous?.should be_true
    end

    it "is false when the duration is positive" do
      event.instantaneous?.should be_false
    end
  end

  describe "#duration_in_pulses" do
    it "multiplies the #length times the argument and rounds to the nearest integer" do
      event.duration_in_pulses(111).should == (event.length * 111).round
    end

    it "is 0 when the #duration is nil" do
      event.duration = nil
      event.duration_in_pulses(111).should == 0
    end
  end

  describe "from_hash" do
    it "constructs an Event using a hash" do
      EVENT.from_hash(hash).should == event
    end
  end

  describe "#to_hash" do
    it "is a hash containing all the attributes of the Event" do
      event.to_hash.should == hash
    end
  end

  describe "#duration_in_pulses" do
    it "converts beats to pulses, given pulses_per_beat" do
      EVENT.new(type, :duration => 1).duration_in_pulses(60).should == 60
    end

    it "rounds to the nearest pulse" do
      EVENT.new(type, :duration => 1.5).duration_in_pulses(59).should == 89
    end

    it "is always positive (uses absolute value of the duration used to construct the Event)" do
      EVENT.new(type, :duration => -1).duration_in_pulses(60).should == 60
    end
  end

  describe "#==" do
    it "is true when the type, number, value, duration and channel are equal" do
      event.should == EVENT.new(type, options)
    end
    it "is false when the types are not equal" do
      event.should_not == EVENT.new(:another_type, options)
    end
    it "is false when the numbers are not equal" do
      event.should_not == EVENT.new(type, options.merge({:number => event.number + 1}))
    end
    it "is false when the values are not equal" do
      event.should_not == EVENT.new(type, options.merge({:value => event.value * 0.5}))
    end
    it "is false when the durations are not equal" do
      event.should_not == EVENT.new(type, options.merge({:duration => event.duration * 2}))
    end
    it "is false when the channels are not equal" do
      event.should_not == EVENT.new(type, options.merge({:channel => event.channel + 1}))
    end
  end

  describe "#to_s" do
    it "has the value and duration to 2-decimal places" do
      EVENT.new(type, :value => 0.454545, :duration => 0.789789).to_s.should == "Event(type, 0.45, 0.79)"
    end
    it "includes the #number when not nil" do
      EVENT.new(type, :value => 0.454545, :duration => 0.789789, :number => 1).to_s.should == "Event(type[1], 0.45, 0.79)"
    end
  end

  describe "#inspect" do
    it "has the string values of value and duration" do
      EVENT.new(:type, :value => 0.454545, :duration => 0.789789).inspect.should == "Event(type, 0.454545, 0.789789)"
    end
    it "includes the #number when not nil" do
      EVENT.new(type, :value => 0.454545, :duration => 0.789789, :number => 1).inspect.should == "Event(type[1], 0.454545, 0.789789)"
    end
  end

end
