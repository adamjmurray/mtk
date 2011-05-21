require 'spec_helper'

describe MTK::Event do

  let(:intensity) { mf }
  let(:duration) { 2.5 }
  let(:event) { Event.new(intensity, duration) }

  describe "#intensity" do
    it "is the intensity used to create the Event" do
      event.intensity.should == intensity
    end

    it "is a read-only attribute" do
      lambda{ event.intensity = 0 }.should raise_error
    end
  end

  describe "#duration" do
    it "is the duration used to create the Event" do
      event.duration.should == duration
    end

    it "is a read-only attribute" do
      lambda{ event.duration = 0 }.should raise_error
    end
  end

  describe "from_hash" do
    it "constructs an Event using a hash" do
      Event.from_hash({ :intensity => intensity, :duration => duration }).should == event
    end
  end

  describe "#to_hash" do
    it "is a hash containing all the attributes of the Event" do
      event.to_hash.should == { :intensity => intensity, :duration => duration }
    end
  end

  describe "#clone_with" do
    it "clones the Event when given an empty hash" do
      event.clone_with({}).should == event
    end

    it "creates an Event with the given :intensity, and the current Event's duration if not provided" do
      event2 = event.clone_with :intensity => (intensity * 0.5)
      event2.intensity.should == (intensity * 0.5)
      event2.duration.should == duration
    end

    it "creates an Event with the given :duration, and the current Event's intensity if not provided" do
      event2 = event.clone_with :duration => (duration * 2)
      event2.intensity.should == intensity
      event2.duration.should == (duration * 2)
    end
  end

  describe '#scale_intensity' do
    it 'multiplies @intensity by the argument' do
      (event.scale_intensity 0.5).should == Event.new(intensity * 0.5, duration)
    end
    it 'does not affect the immutability of the Evebt' do
      (event.scale_intensity 0.5).should_not == event
    end
  end

  describe '#scale_duration' do
    it 'multiplies @duration by the argument' do
      (event.scale_duration 2).should == Event.new(intensity, duration*2)
    end
    it 'does not affect the immutability of the Event' do
      (event.scale_duration 0.5).should_not == event
    end
  end

  describe "#velocity" do
    it "converts intensities in the range 0.0-1.0 to a MIDI velocity in the range 0-127" do
      Event.new(0, 0).velocity.should == 0
      Event.new(1, 0).velocity.should == 127
    end
    it "rounds to the nearest MIDI velocity" do
      Event.new(0.5, 0).velocity.should == 64 # not be truncated to 63!
    end
  end

  describe "#duration_in_pulses" do
    it "converts beats to pulses, given pulses_per_beat" do
      Event.new(0,1).duration_in_pulses(60).should == 60
    end
    it "rounds to the nearest pulse" do
      Event.new(0,1.5).duration_in_pulses(59).should == 89
    end
  end

  describe "#==" do
    it "is true when the intensities and durations are equal" do
      event.should == Event.new(intensity, duration)
    end
    it "is false when the intensities are not equal" do
      event.should_not == Event.new(intensity * 0.5, duration)
    end
    it "is false when the durations are not equal" do
      event.should_not == Event.new(intensity, duration * 2)
    end
  end

  describe "#to_s" do
    it "is the intensity and duration to 2-decimal places" do
      Event.new(0.454545, 0.789789).to_s.should == "0.45, 0.79"
    end
  end

  describe "#inspect" do
    it "is the string values of intensity and duration" do
      Event.new(0.454545, 0.789789).inspect.should == "0.454545, 0.789789"
    end
  end

end
