require 'mtk/midi/dls_synth_device'

module MTK
  module MIDI

    # Provides realtime MIDI output on OS X to the built-in "DLS" Synthesizer
    # @note This class is optional and only available if you require 'mtk/midi/dls_synth_output'.
    #       It depends on the 'gamelan' gem.
    class DLSSynthOutput < Output

      public_class_method :new

      def self.devices
        @devices ||= [DLSSynthDevice.new]
      end

      def self.devices_by_name
        @devices_by_name ||= {devices.first.name => devices.first}
      end


      ######################
      protected

      # (see Output#note_on)
      def note_on(pitch, velocity, channel)
        @device.message(0x90|channel, pitch, velocity)
      end

      # (see Output#note_off)
      def note_off(pitch, velocity, channel)
        @device.message(0x80|channel, pitch, velocity)
      end

      # (see Output#control)
      def control(number, midi_value, channel)
        @device.message(0xB0|channel, number, midi_value)
      end

      # (see Output#channel_pressure)
      def channel_pressure(midi_value, channel)
        @device.message(0xD0|channel, midi_value, 0)
      end

      # (see Output#poly_pressure)
      def poly_pressure(pitch, midi_value, channel)
        @device.message(0xA0|channel, pitch, midi_value)
      end

      # (see Output#bend)
      def bend(midi_value, channel)
        @device.message(0xE0|channel, midi_value & 127, (midi_value >> 7) & 127)
      end

      # (see Output#program)
      def program(number, channel)
        @device.message(0xC0|channel, number, 0)
      end
    end
  end
end

