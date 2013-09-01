require 'jsound'

module MTK
  module IO

    # Provides realtime MIDI output for JRuby via the jsound and gamelan gems.
    # @note This class will be loaded if available when you require 'mtk/io/midi_output'.
    #       It depends on the 'jsound' and 'gamelan' gems.
    class JSoundOutput < MIDIOutput

      public_class_method :new

      def self.devices
        @devices ||= ::JSound::Midi::OUTPUTS.devices
      end

      def self.devices_by_name
        @devices_by_name ||= devices.each_with_object( Hash.new ){|device,hash| hash[device.description] = device }
      end


      def initialize(device, options={})
        @device = device

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

      def name
        @device.description
      end

      ######################
      protected

      # (see MIDIOutput#note_on)
      def note_on(pitch, velocity, channel)
        @generator.note_on(pitch, velocity, channel)
      end

      # (see MIDIOutput#note_off)
      def note_off(pitch, velocity, channel)
        @generator.note_off(pitch, velocity, channel)
      end

      # (see MIDIOutput#control)
      def control(number, midi_value, channel)
        @generator.control_change(number, midi_value, channel)
      end

      # (see MIDIOutput#channel_pressure)
      def channel_pressure(midi_value, channel)
        @generator.channel_pressure(midi_value, channel)
      end

      # (see MIDIOutput#poly_pressure)
      def poly_pressure(pitch, midi_value, channel)
        @generator.poly_pressure(pitch, midi_value, channel)
      end

      # (see MIDIOutput#bend)
      def bend(midi_value, channel)
        @generator.pitch_bend(midi_value, channel)
      end

      # (see MIDIOutput#program)
      def program(number, channel)
        @generator.program_change(number, channel)
      end

    end
  end
end

