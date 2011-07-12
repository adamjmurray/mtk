require 'mtk/midi/abstract_output'
require 'jsound'

module MTK
  module MIDI

    # Provides realtime MIDI output for JRuby via the jsound and gamelan gems.
    # @note This class is optional and only available if you require 'mtk/midi/jsound_output'.
    #       It depends on the 'jsound' and 'gamelan' gems.
    class JSoundOutput < AbstractOutput

      attr_reader :device

      def initialize(output, options={})
        if output.is_a? ::JSound::Midi::Device
          @device = output
        else
          @device = ::JSound::Midi::OUTPUTS.send output
        end

        @generator = ::JSound::Midi::Devices::Generator.new
        if options[:monitor]
          @monitor = ::JSound::Midi::Devices::Monitor.new
          @generator >> [@monitor, @device]
        else
          @generator >> @device
        end
        @device.open
      end


      ######################
      protected

      # (see AbstractOutput#note_on)
      def note_on(pitch, velocity, channel=0)
        lambda { @generator.note_on(pitch, velocity, channel) }
      end

      # (see AbstractOutput#note_off)
      def note_off(pitch, velocity, channel=0)
        lambda { @generator.note_off(pitch, velocity, channel) }
      end

      # (see AbstractOutput#control)
      def control(number, midi_value, channel)
        lambda { @generator.control_change(number, midi_value, channel) }
      end

      # (see AbstractOutput#channel_pressure)
      def channel_pressure(midi_value, channel)
        lambda { @generator.channel_pressure(midi_value, channel) }
      end

      # (see AbstractOutput#poly_pressure)
      def poly_pressure(pitch, midi_value, channel)
        lambda { @generator.poly_pressure(pitch, midi_value, channel) }
      end

      # (see AbstractOutput#bend)
      def bend(midi_value, channel)
        lambda { @generator.pitch_bend(midi_value, channel) }
      end

      # (see AbstractOutput#program)
      def program(number, channel)
        lambda { @generator.program_change(number, channel) }
      end

    end
  end
end

