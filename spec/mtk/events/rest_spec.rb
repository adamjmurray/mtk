require 'spec_helper'

describe MTK::Events::Rest do

  REST = MTK::Events::Rest

  let(:duration) { -7.5 }
  let(:channel) { 3 }
  let(:rest) { REST.new duration, channel }
  let(:hash) { {type: :rest, duration: duration, channel: channel} }


  describe ".new" do
    it "requires a duration as the first argument" do
      lambda{ REST.new() }.should raise_error
    end

    it "coerces the duration to an MTK::Core::Duration" do
      rest.duration.should be_a MTK::Core::Duration
    end

    it "forces the duration value negative to be a rest, if needed" do
      REST.new(5).duration.should == -5
    end
  end

  describe "#type" do
    it "is :rest" do
      rest.type.should == :rest
    end

    it "is a read-only attribute" do
      lambda{ rest.type = :anything }.should raise_error
    end
  end

  describe "#duration" do
    it "is the value of the first argument to Rest.new, if the value was negative (indicating a rest)" do
      rest.duration.should == duration
    end
  end

  describe "#duration=" do
    it "sets #duration" do
      rest.duration = -42
      rest.duration.should == -42
    end

    it "forces coerces argument to a MTK::Core::Duration" do
      rest.duration = 42
      rest.duration.should be_a MTK::Core::Duration
    end

    it "forces the duration value negative to be a rest, if needed" do
      rest.duration = 42
      rest.duration.should == -42
    end
  end

  describe "#channel" do
    it "is the value of the :channel key in the options hash passed to Rest.new" do
      rest.channel.should == channel
    end

    it "defaults to nil" do
      REST.new(duration).channel.should be_nil
    end
  end

  describe "#channel=" do
    it "sets #channel" do
      rest.channel = 12
      rest.channel.should == 12
    end
  end

  describe "#midi_value" do
    it "is nil" do
      rest.midi_value.should be_nil
    end
  end

  describe "#length" do
    it "is the absolute value of duration" do
      rest.duration = -5
      rest.length.should == 5
    end
  end

  describe "#rest?" do
    it "is true when the duration is negative" do
      rest.rest?.should be_true
    end

    it "is true event with a positive duration, because the duration was forced negative" do
      rest.duration = 5
      rest.rest?.should be_true
    end
  end

  describe "from_h" do
    it "constructs an Event using a hash" do
      REST.from_h(hash).should == rest
    end
  end

  describe "#to_h" do
    it "is a hash containing all the attributes of the Rest" do
      rest.to_h.should == hash
    end
  end


  describe "#==" do
    it "is true when the duration and channel are equal" do
      rest.should == REST.new(duration, channel)
    end

    it "is false when the durations are not equal" do
      rest.should_not == REST.new(duration+1, channel)
    end

    it "is false when the channels are not equal" do
      rest.should_not == REST.new(duration, channel+1)
    end
  end

  describe "#to_s" do
    it "includes #duration to 2 decimal places" do
      REST.new(Duration(-1/3.0)).to_s.should == "Rest(-0.33 beat)"
    end
  end

  describe "#inspect" do
    it 'is "#<MTK::Events::Rest:{object_id} @duration={duration.inspect}, @channel={channel}>"' do
      rest.inspect.should == "#<MTK::Events::Rest:#{rest.object_id} @duration=#{rest.duration.inspect}, @channel=#{channel}>"
    end
  end

end


describe MTK do

  describe '#Rest' do

    it "acts like new for multiple arguments" do
      MTK::Rest(4,2).should == REST.new(4,2)
    end

    it "acts like new for an Array of arguments by unpacking (splatting) them" do
      MTK::Rest([4,2]).should == REST.new(4,2)
    end

    it "returns the argument if it's already a Rest" do
      rest = REST.new(4,2)
      MTK::Rest(rest).should be_equal(rest)
    end

    it "makes a Rest of the same duration and channel from other Event types" do
      event = MTK::Events::Event.new(:event_type, duration:5, channel:3)
      MTK::Rest(event).should == REST.new(5,3)
    end

    it "handles a single Numeric argument" do
      MTK::Rest(4).should == REST.new(4)
    end

    it "handles a single Duration argument" do
      MTK.Rest(MTK.Duration(4)).should == REST.new(4)
    end

    it "raises an error for types it doesn't understand" do
      lambda{ MTK::Rest({:not => :compatible}) }.should raise_error
    end

    it "handles out of order arguments for recognized Duration types" do
      MTK::Rest(2,q).should == REST.new(q,2)
    end

  end

end

