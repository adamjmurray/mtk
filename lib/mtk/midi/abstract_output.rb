require 'rubygems'
require 'gamelan'

module MTK
  module MIDI

    # Provides a scheduler and common behavior for realtime MIDI output, using the gamelan gem for scheduling.
    #
    # @abstract Subclass and override {#note_on}, {#note_off}, {#control}, {#channel_pressure}, {#poly_pressure}, {#bend}, and {#program} to implement a MIDI output.
    #
    class AbstractOutput

      def play(timeline, options={})
        scheduler_rate = options.fetch :scheduler_rate, 500 # default: 500 Hz
        trailing_buffer = options.fetch :trailing_buffer, 2 # default: continue playing for 2 beats after the end of the timeline
        in_background = options.fetch :background, false # default: don't run in background Thread
        bpm = options.fetch :bmp, 120 # default: 120 beats per minute

        @scheduler = Gamelan::Scheduler.new :tempo => bpm, :rate => scheduler_rate

        for time,events in timeline
          for event in events
            channel = event.channel || 0

            case event.type
              when :note
                pitch, velocity, duration = event.to_midi
                at time, note_on(pitch,velocity,channel)
                time += duration
                at time, note_off(pitch,velocity,channel)

              when :control
                at time, control(event.number, event.midi_value, channel)

              when :pressure
                if event.number
                  at time, poly_pressure(event.number, event.midi_value, channel)
                else
                  at time, channel_pressure(event.midi_value, channel)
                end

              when :bend
                at time, bend(event.midi_value, channel)

              when :program
                at time, program(event.number, channel)
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

      # Create a Proc that will send a note on event to the MIDI output
      def note_on(midi_pitch, velocity, channel)
        lambda{ [:note_on, midi_pitch, velocity, channel] } # stubbed data for testing purposes
      end

      # Create a Proc that will send a note off event to the MIDI output
      def note_off(midi_pitch, velocity, channel)
        lambda{ [:note_off, midi_pitch, velocity, channel] } # stubbed data for testing purposes
      end

      # Create a Proc that will send a control change event to the MIDI output
      def control(number, midi_value, channel)
        lambda{ [:control, number, midi_value, channel] } # stubbed data for testing purposes
      end

      # Create a Proc that will send a poly pressure event to the MIDI output.
      def poly_pressure(midi_pitch, midi_value, channel)
        lambda{ [:poly_pressure, midi_pitch, midi_value, channel] } # stubbed data for testing purposes
      end

      # Create a Proc that will send a channel pressure event to the MIDI output.
      def channel_pressure(midi_value, channel)
        lambda{ [:channel_pressure, midi_value, channel] } # stubbed data for testing purposes
      end

      # Create a Proc that will send a pitch bend event to the MIDI output.
      def bend(midi_value, channel)
        lambda{ [:bend, midi_value, channel] } # stubbed data for testing purposes
      end

      # Create a Proc that will send a program change event to the MIDI output.
      def program(number, channel)
        lambda{ [:program, number, channel] }
      end

      ######################
      private

      # Schedule a block to run at a particular time
      def at time, block
        @scheduler.at(time) { block.call }
      end

    end

  end
end

