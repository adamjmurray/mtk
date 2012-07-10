require 'mtk/midi/output'
require 'jsound'

module MTK
  module MIDI

    # Provides realtime MIDI output for JRuby via the jsound and gamelan gems.
    # @note This class is optional and only available if you require 'mtk/midi/jsound_output'.
    #       It depends on the 'jsound' and 'gamelan' gems.
    class JSoundOutput < Output

      def initialize(output, options={})
        @device = output

        # and create an object for generating MIDI message to send to the output:
        @generator = ::JSound::Midi::Devices::Generator.new

        if options[:monitor]
          @monitor = ::JSound::Midi::Devices::Monitor.new
          @generator >> [@monitor, @device]
        else
          @generator >> @device
        end
        @device.open
      end

      def self.devices
        @devices ||= ::JSound::Midi::OUTPUTS.devices
      end

      def self.devices_by_name
        @devices_by_name ||= devices.each_with_object( Hash.new ){|device,hash| hash[device.description] = device }
      end

      ######################
      protected

      # (see Output#note_on)
      def note_on(pitch, velocity, channel)
        lambda { @generator.note_on(pitch, velocity, channel) }
      end

      # (see Output#note_off)
      def note_off(pitch, velocity, channel)
        lambda { @generator.note_off(pitch, velocity, channel) }
      end

      # (see Output#control)
      def control(number, midi_value, channel)
        lambda { @generator.control_change(number, midi_value, channel) }
      end

      # (see Output#channel_pressure)
      def channel_pressure(midi_value, channel)
        lambda { @generator.channel_pressure(midi_value, channel) }
      end

      # (see Output#poly_pressure)
      def poly_pressure(pitch, midi_value, channel)
        lambda { @generator.poly_pressure(pitch, midi_value, channel) }
      end

      # (see Output#bend)
      def bend(midi_value, channel)
        lambda { @generator.pitch_bend(midi_value, channel) }
      end

      # (see Output#program)
      def program(number, channel)
        lambda { @generator.program_change(number, channel) }
      end

    end
  end
end

