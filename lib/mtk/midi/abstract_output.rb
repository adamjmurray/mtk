require 'rubygems'
require 'gamelan'

module MTK
  module MIDI

    # Provides a scheduler and common behavior for realtime MIDI output, using the gamelan gem for scheduling.
    # @abstract Subclass and override {#note_on} and {#note_off}
    class AbstractOutput

      def play(timeline, options={})
        scheduler_rate = options.fetch :scheduler_rate, 500 # default: 500 Hz
        trailing_buffer = options.fetch :trailing_buffer, 2 # default: continue playing for 2 beats after the end of the timeline
        in_background = options.fetch :background, false # default: don't run in background Thread
        bpm = options.fetch :bmp, 120 # default: 120 beats per minute

        @scheduler = Gamelan::Scheduler.new :tempo => bpm, :rate => scheduler_rate

        for time,events in timeline
          for event in events
            case event
              when Note
                pitch, velocity, duration = event.to_midi
                at time, note_on(pitch,velocity)
                time += duration
                at time, note_off(pitch,velocity)
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

      # Create a Proc that will send a note_on event to the MIDI output
      def note_on(pitch, velocity, channel=0)
      end

      # Create a Proc that will send a note_off event to the MIDI output
      def note_off(pitch, velocity, channel=0)
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

