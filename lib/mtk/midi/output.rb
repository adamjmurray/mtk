require 'rubygems'
require 'gamelan'

module MTK
  module MIDI

    # Provides a scheduler and common behavior for realtime MIDI output, using the gamelan gem for scheduling.
    #
    # @abstract Subclasses must provide {.devices}, {.devices_by_name}, {#note_on}, {#note_off}, {#control}, {#channel_pressure}, {#poly_pressure}, {#bend}, and {#program} to implement a MIDI output.
    #
    class Output

      # The underlying output device implementation wrapped by this class.
      # The device type depends on the platform.
      attr_reader :device

      class << self

        # All available output devices.
        def devices
          @devices_by_name ||= []
        end

        # Maps output device names to the output device.
        def devices_by_name
          @devices_by_name ||= {}
        end

        def find_by_name name
          if name.is_a? Regexp
            matching_name = devices_by_name.keys.find{|device_name| device_name =~ name }
            device = devices_by_name[matching_name]
          else
            device = devices_by_name[name.to_s]
          end
          new device if device
        end

      end


      def play(anything, options={})
        timeline = case anything
          when Array,MTK::Event::AbstractEvent then MTK::Timeline.from_hash(0 => anything)
          when Hash then MTK::Timeline.from_hash anything
          when MTK::Timeline then anything
          else "#{self.class}.play() doesn't understand #{anything} (#{anything.class})"
        end

        scheduler_rate = options.fetch :scheduler_rate, 500 # default: 500 Hz
        trailing_buffer = options.fetch :trailing_buffer, 2 # default: continue playing for 2 beats after the end of the timeline
        in_background = options.fetch :background, false # default: don't run in background Thread
        bpm = options.fetch :bmp, 120 # default: 120 beats per minute

        @scheduler = Gamelan::Scheduler.new :tempo => bpm, :rate => scheduler_rate

        timeline.each do |time,events|
          events.each do |event|
            channel = event.channel || 0

            case event.type
              when :note
                pitch, velocity, duration = event.to_midi
                @scheduler.at(time) { note_on(pitch,velocity,channel) }
                @scheduler.at(time + duration) { note_off(pitch,velocity,channel) }

              when :control
                @scheduler.at(time) { control(event.number, event.midi_value, channel) }

              when :pressure
                if event.number
                  @scheduler.at(time) { poly_pressure(event.number, event.midi_value, channel) }
                else
                  @scheduler.at(time) { channel_pressure(event.midi_value, channel) }
                end

              when :bend
                @scheduler.at(time) { bend(event.midi_value, channel) }

              when :program
                @scheduler.at(time) { program(event.number, channel) }
            end
          end
        end

        end_time = timeline.times.last + trailing_buffer
        @scheduler.at(end_time) { @scheduler.stop }

        thread = @scheduler.run
        thread.join if not in_background
      end


      ########################
      protected

      # these all return stubbed data for testing purposes

      # Send a note on event to the MIDI output
      def note_on(midi_pitch, velocity, channel)
        [:note_on, midi_pitch, velocity, channel] # stubbed data for testing purposes
      end

      # Send a note off event to the MIDI output
      def note_off(midi_pitch, velocity, channel)
        [:note_off, midi_pitch, velocity, channel]
      end

      # Send a control change event to the MIDI output
      def control(number, midi_value, channel)
        [:control, number, midi_value, channel]
      end

      # Send a poly pressure event to the MIDI output.
      def poly_pressure(midi_pitch, midi_value, channel)
        [:poly_pressure, midi_pitch, midi_value, channel]
      end

      # Send a channel pressure event to the MIDI output.
      def channel_pressure(midi_value, channel)
        [:channel_pressure, midi_value, channel]
      end

      # Send a pitch bend event to the MIDI output.
      def bend(midi_value, channel)
        [:bend, midi_value, channel]
      end

      # Send a program change event to the MIDI output.
      def program(number, channel)
        [:program, number, channel]
      end

    end

  end
end

