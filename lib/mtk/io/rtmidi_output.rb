require 'rtmidi'
require 'ostruct'

module MTK
  module IO

    # Provides realtime MIDI output for JRuby via the rtmidi and gamelan gems.
    # @note This class will be loaded if available when you require 'mtk/io/midi_output'.
    #       It depends on the 'rtmidi' and 'gamelan' gems.
    class RtMidiOutput < MIDIOutput

      public_class_method :new


      def self.devices
        @devices ||= devices_by_name.map{|key,value| OpenStruct.new(name:key, port_index:value) }
      end

      def self.devices_by_name
        @devices_by_name ||= (
          @midiout = RtMidi::Out.new
          hash = {}
          @midiout.port_names.each_with_index do |name,index|
            dedup = 1
            orig_name = name
            while hash.include?(name) # handle ports with duplicate names
              dedup += 1
              name = "#{orig_name}(#{dedup})"
            end
            hash[name] = index
          end
          hash
        )
      end


      attr_reader :device

      def initialize(device_id, options={})
        if device_id.respond_to? :port_index
          port_index = device_id.port_index
        else
          port_index = device_id
        end
        @device = RtMidi::Out.new
        @name = @device.port_name(port_index)
        @options = options

        @device.open_port(port_index)
      end

      def name
        @name
      end


      ######################
      protected

      # (see MIDIOutput#note_on)
      def note_on(pitch, velocity, channel)
        @device.send_message(0x90|channel, pitch, velocity)
      end

      # (see MIDIOutput#note_off)
      def note_off(pitch, velocity, channel)
        @device.send_message(0x80|channel, pitch, velocity)
      end

      # (see MIDIOutput#control)
      def control(number, midi_value, channel)
        @device.send_message(0xB0|channel, number, midi_value)
      end

      # (see MIDIOutput#channel_pressure)
      def channel_pressure(midi_value, channel)
        @device.send_message(0xD0|channel, midi_value, 0)
      end

      # (see MIDIOutput#poly_pressure)
      def poly_pressure(pitch, midi_value, channel)
        @device.send_message(0xA0|channel, pitch, midi_value)
      end

      # (see MIDIOutput#bend)
      def bend(midi_value, channel)
        @device.send_message(0xE0|channel, midi_value & 127, (midi_value >> 7) & 127)
      end

      # (see MIDIOutput#program)
      def program(number, channel)
        @device.send_message(0xC0|channel, number, 0)
      end

    end
  end
end

