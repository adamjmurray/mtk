require 'mtk/midi/abstract_output'
require 'unimidi'

module MTK
  module MIDI

    # Provides realtime MIDI output for MRI/YARV Ruby via the unimidi and gamelan gems.
    # @note This class is optional and only available if you require 'mtk/midi/unimidi_output'.
    #       It depends on the 'unimidi' and 'gamelan' gems.
    class UniMIDIOutput < AbstractOutput

      attr_reader :device

      def initialize(output, options={})
        if output.is_a? ::UniMIDI::CongruousApiOutput
          @device = output
        else
          output = /#{output.to_s.sub '_','.*'}/i unless output.is_a? Regexp
          @device = ::UniMIDI::Output.all.find {|o| o.name =~ output }
        end
        @device.open
      end


      ######################
      protected

      # (see AbstractOutput#note_on)
      def note_on(pitch, velocity, channel)
        lambda { @device.puts(0x90|channel, pitch, velocity) }
      end

      # (see AbstractOutput#note_off)
      def note_off(pitch, velocity, channel)
        lambda { @device.puts(0x80|channel, pitch, velocity) }
      end

      # (see AbstractOutput#control)
      def control(number, midi_value, channel)
        lambda { @device.puts(0xB0|channel, number, midi_value) }
      end

      # (see AbstractOutput#channel_pressure)
      def channel_pressure(midi_value, channel)
        lambda { @device.puts(0xD0|channel, midi_value, 0) }
      end

      # (see AbstractOutput#poly_pressure)
      def poly_pressure(pitch, midi_value, channel)
        lambda { @device.puts(0xA0|channel, pitch, midi_value) }
      end

      # (see AbstractOutput#bend)
      def bend(midi_value, channel)
        lambda { @device.puts(0xE0|channel, midi_value & 127, (midi_value >> 7) & 127) }
      end

      # (see AbstractOutput#program)
      def program(number, channel)
        lambda { @device.puts(0xC0|channel, number, 0) }
      end

    end
  end
end

