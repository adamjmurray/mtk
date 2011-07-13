require 'spec_helper'

describe MTK::Event::Parameter do

  PARAMETER = MTK::Event::Parameter


  describe ".from_midi" do

    context "poly pressure events" do

      context "first arg is the status byte" do
        it "parses :pressure #type on channel 0" do
          PARAMETER.from_midi(0xA0, 0, 0).type.should == :pressure
        end
        it "parses :pressure #type on other channels" do
          PARAMETER.from_midi(0xA0 | 5, 0, 0).type.should == :pressure
        end
        it "parses the #channel" do
          PARAMETER.from_midi(0xA0 | 5, 0, 0).channel.should == 5
        end
      end

      context "first arg is an array of [type,channel]" do
        it "converts :poly_pressure to :pressure #type" do
          PARAMETER.from_midi([:poly_pressure, 0], 0, 0).type.should == :pressure
        end
        it "extracts the #channel" do
          PARAMETER.from_midi([:poly_pressure, 5], 0, 0).channel.should == 5
        end
      end

      it "sets #number (pitch) to the data1 byte" do
        PARAMETER.from_midi(0xA0, 100, 50).number.should == 100
      end

      it "set #value to the data2 byte / 127.0" do
        PARAMETER.from_midi(0xA0, 100, 50).value.should == 50/127.0
      end
    end


    context "control change events" do

      context "first arg is the status byte" do
        it "parses :control #type on channel 0" do
          PARAMETER.from_midi(0xB0, 0, 0).type.should == :control
        end
        it "parses :control #type on other channels" do
          PARAMETER.from_midi(0xB0 | 5, 0, 0).type.should == :control
        end
        it "parses the #channel" do
          PARAMETER.from_midi(0xB0 | 5, 0, 0).channel.should == 5
        end
      end

      context "first arg is an array of [type,channel]" do
        it "converts :control_change :control #type" do
          PARAMETER.from_midi([:control_change, 0], 0, 0).type.should == :control
        end
        it "extracts the #channel" do
          PARAMETER.from_midi([:control_change, 5], 0, 0).channel.should == 5
        end
      end

      it "sets #number to the data1 byte" do
        PARAMETER.from_midi(0xB0, 100, 50).number.should == 100
      end

      it "set #value to the data2 byte / 127.0" do
        PARAMETER.from_midi(0xB0, 100, 50).value.should == 50/127.0
      end
    end


    context "program change events" do

      context "first arg is the status byte" do
        it "parses :program #type on channel 0" do
          PARAMETER.from_midi(0xC0, 0, 0).type.should == :program
        end
        it "parses :program #type on other channels" do
          PARAMETER.from_midi(0xC0 | 5, 0, 0).type.should == :program
        end
        it "parses the #channel" do
          PARAMETER.from_midi(0xC0 | 5, 0, 0).channel.should == 5
        end
      end

      context "first arg is an array of [type,channel]" do
        it "converts :program_change :program #type" do
          PARAMETER.from_midi([:program_change, 0], 0, 0).type.should == :program
        end
        it "extracts the #channel" do
          PARAMETER.from_midi([:program_change, 5], 0, 0).channel.should == 5
        end
      end

      it "sets #number to the data1 byte" do
        PARAMETER.from_midi(0xC0, 100, 0).number.should == 100
      end

      it "does not set #value" do
        PARAMETER.from_midi(0xC0, 100, 0).value.should be_nil
      end
    end


    context "channel pressure events" do

      context "first arg is the status byte" do
        it "parses :pressure #type on channel 0" do
          PARAMETER.from_midi(0xD0, 0, 0).type.should == :pressure
        end
        it "parses :pressure #type on other channels" do
          PARAMETER.from_midi(0xD0 | 5, 0, 0).type.should == :pressure
        end
        it "parses the #channel" do
          PARAMETER.from_midi(0xD0 | 5, 0, 0).channel.should == 5
        end
      end

      context "first arg is an array of [type,channel]" do
        it "converts :channel_pressure to :pressure #type" do
          PARAMETER.from_midi([:channel_pressure, 0], 0, 0).type.should == :pressure
        end
        it "extracts the #channel" do
          PARAMETER.from_midi([:channel_pressure, 5], 0, 0).channel.should == 5
        end
      end

      it "does not set #number" do
        PARAMETER.from_midi(0xD0, 50, 0).number.should be_nil
      end

      it "set #value to the data1 byte / 127.0" do
        PARAMETER.from_midi(0xD0, 50, 0).value.should == 50/127.0
      end
    end


    context "pitch bend events" do

      context "first arg is the status byte" do
        it "parses :bend #type on channel 0" do
          PARAMETER.from_midi(0xE0, 0, 0).type.should == :bend
        end
        it "parses :bend #type on other channels" do
          PARAMETER.from_midi(0xE0 | 5, 0, 0).type.should == :bend
        end
        it "parses the #channel" do
          PARAMETER.from_midi(0xE0 | 5, 0, 0).channel.should == 5
        end
      end

      context "first arg is an array of [type,channel]" do
        it "converts :pitch_bend :bend #type" do
          PARAMETER.from_midi([:pitch_bend, 0], 0, 0).type.should == :bend
        end
        it "extracts the #channel" do
          PARAMETER.from_midi([:pitch_bend, 5], 0, 0).channel.should == 5
        end
      end

      it "does not set #number" do
        PARAMETER.from_midi(0xE0, 50, 0).number.should be_nil
      end

      it "sets #value by combining the data1 (lsb) and data2 (msb) bytes into a 14-bit int and then mapping to the range -1.0..1.0" do
        PARAMETER.from_midi(0xE0,   0,   0).value.should == -1.0
        PARAMETER.from_midi(0xE0,   0,  64).value.should == 0
        PARAMETER.from_midi(0xE0, 127, 127).value.should == 1.0
      end
    end


    context "unknown events" do
      it "sets #type to :unknown" do
        PARAMETER.from_midi(0xF0, 50, 100).type.should == :unknown
      end

      it "sets #number to the data1 byte" do
        PARAMETER.from_midi(0xF0, 50, 100).number.should == 50
      end

      it "sets #value to the data2 byte / 127.0" do
        PARAMETER.from_midi(0xF0, 50, 100).value.should == 100/127.0
      end
    end

  end


  describe "#midi_value" do
    it "special cases :bend type events to map the range -1.0..1.0 back to a 14-bit int" do
      PARAMETER.from_midi([:pitch_bend,0],   0,   0).midi_value.should == 0
      PARAMETER.from_midi([:pitch_bend,0],   0,  64).midi_value.should == 8192
      PARAMETER.from_midi([:pitch_bend,0], 127, 127).midi_value.should == 16383
    end

    it "maps back to the original midi value for other cases" do
      PARAMETER.from_midi([:control_change,0], 0, 50).midi_value.should == 50
    end
  end


  describe "#to_s" do
    it "includes the #type, #number, and #value to 2 decimal places" do
      PARAMETER.from_midi([:control_change,0], 50, 100).to_s.should == "Parameter(control[50], 0.79)"
    end
  end

  describe "#inspect" do
    it "includes the #type, #number, and #value.to_s" do
      PARAMETER.from_midi([:control_change,0], 50, 100).inspect.should == "Parameter(control[50], 0.7874015748031497)"
    end
  end

end

