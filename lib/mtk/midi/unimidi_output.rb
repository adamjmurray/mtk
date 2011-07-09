require 'mtk/midi/abstract_output'
require 'unimidi'

module MTK
  module MIDI

    # Provides MIDI output via the unimidi and gamelan gems
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
      def note_on(pitch, velocity, channel=0)
        lambda { @device.puts(0x90|channel, pitch, velocity) }
      end

      # (see AbstractOutput#note_off)
      def note_off(pitch, velocity, channel=0)
        lambda { @device.puts(0x80|channel, pitch, velocity) }
      end

    end
  end
end

