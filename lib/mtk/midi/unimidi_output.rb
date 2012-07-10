require 'mtk/midi/output'
require 'unimidi'

module MTK
  module MIDI

    # Provides realtime MIDI output for "standard" Ruby (MRI) via the unimidi and gamelan gems.
    # @note This class is optional and only available if you require 'mtk/midi/unimidi_output'.
    #       It depends on the 'unimidi' and 'gamelan' gems.
    class UniMIDIOutput < Output

      attr_reader :device

      def initialize(output_device, options={})
        @device = output_device
        @device.open
      end

      def self.devices
        @devices ||= ::UniMIDI::Output.all
      end

      def self.devices_by_name
        @devices_by_name ||= devices.each_with_object( Hash.new ){|device,hash| hash[device.name] = device }
      end

      ######################
      protected

      # (see Output#note_on)
      def note_on(pitch, velocity, channel)
        @device.puts(0x90|channel, pitch, velocity)
      end

      # (see Output#note_off)
      def note_off(pitch, velocity, channel)
        @device.puts(0x80|channel, pitch, velocity)
      end

      # (see Output#control)
      def control(number, midi_value, channel)
        @device.puts(0xB0|channel, number, midi_value)
      end

      # (see Output#channel_pressure)
      def channel_pressure(midi_value, channel)
        @device.puts(0xD0|channel, midi_value, 0)
      end

      # (see Output#poly_pressure)
      def poly_pressure(pitch, midi_value, channel)
        @device.puts(0xA0|channel, pitch, midi_value)
      end

      # (see Output#bend)
      def bend(midi_value, channel)
        @device.puts(0xE0|channel, midi_value & 127, (midi_value >> 7) & 127)
      end

      # (see Output#program)
      def program(number, channel)
        @device.puts(0xC0|channel, number, 0)
      end

    end
  end
end

