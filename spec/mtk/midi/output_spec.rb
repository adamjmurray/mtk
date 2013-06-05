require 'spec_helper'
require 'mtk/midi/output'

describe MTK::MIDI::Output do

  let(:mock_device) do
    mock_device = mock(:device)
    mock_device.stub(:open)
    mock_device
  end

  let(:subject) { MTK::MIDI::Output.new(mock_device) }

  let(:scheduler) do
    scheduler = mock(:scheduler)
    Gamelan::Scheduler.stub(:new).and_return scheduler
    scheduler
  end


  def timeline_with_param_event(event_type, event_options={})
    event = MTK::Events::Parameter.new event_type, event_options
    MTK::Timeline.from_hash 0 => event
  end

  def should_be_scheduled timed_data
    timed_data.each do |time,data|
      scheduler.should_receive(:at) do |scheduled_time,&callback|
        scheduled_time.should == time
        callback.yield.should == data
      end
    end
    scheduler.should_receive(:at) # end time, don't care about this here...
    scheduler.should_receive(:run).and_return mock(:thread,:join=>nil)
  end


  describe ".new" do
    it "opens the given device" do
      mock_device.should_receive(:open)
      subject
    end
  end

  describe "#play" do

    it "handles note events" do
      should_be_scheduled 0 => [:note_on,  60, 127, 0],
                          1 => [:note_off, 60, 127, 0]
      subject.play MTK::Timeline.from_hash( 0 => Note(C4,fff,1) )
    end

    it "handles control events" do
      should_be_scheduled 0 => [:control, 5, 32, 3]
      subject.play timeline_with_param_event(:control, number:5, value:0.25, channel:3)
    end

    it "handles channel pressure events" do
      should_be_scheduled 0 => [:channel_pressure, 64, 0]
      subject.play timeline_with_param_event(:pressure, value:0.5)
    end

    it "handles poly pressure events" do
      should_be_scheduled 0 => [:poly_pressure, 60, 127, 0]
      subject.play timeline_with_param_event(:pressure, number:60, value:1)
    end

    it "handles bend events" do
      should_be_scheduled 0 => [:bend, 0, 0]
      subject.play timeline_with_param_event(:bend, value: -1)
    end

    it "handles program events" do
      should_be_scheduled 0 => [:program, 7, 9]
      subject.play timeline_with_param_event(:program, number:7, channel:9)
    end

    it "handles simultaneous events" do
      should_be_scheduled [
        [0, [:note_on,  60, 127, 0]],
        [1, [:note_off, 60, 127, 0]],
        [0, [:note_on,  67, 127, 0]],
        [1, [:note_off, 67, 127, 0]]
      ]
      subject.play [Note(C4,fff,1),Note(G4,fff,1)]
    end

    it "handles a list of timelines" do
      should_be_scheduled  0 => [:note_on,  60, 127, 0],
                           1 => [:note_off, 60, 127, 0],
                           2 => [:note_on,  67, 127, 0],
                           3 => [:note_off, 67, 127, 0]
      subject.play [MTK::Timeline.from_hash( 0 => Note(C4,fff,1) ), MTK::Timeline.from_hash( 2 => Note(G4,fff,1) )]
    end

  end

end
