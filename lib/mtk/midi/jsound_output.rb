require 'mtk/midi/abstract_output'
require 'jsound'

module MTK
  module MIDI

    # Provides MIDI output for JRuby via the jsound and gamelan gems
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

    end
  end
end

