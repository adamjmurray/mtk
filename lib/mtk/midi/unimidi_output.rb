require 'rubygems'
require 'unimidi'
require 'gamelan'

module MTK
  module MIDI

    # Provides MIDI output via the unimidi and gamelan gems
    class UniMIDIOutput

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

      ######################
      private

      # It's necessary to generate the events through methods and lambdas like this to create closures.

      def note_on(pitch, velocity)
        # TODO: support channel via 0x90 | channel
        lambda { @device.puts(0x90, pitch, velocity) }
      end

      def note_off(pitch, velocity)
        # TODO: support channel via 0x80 | channel
        lambda { @device.puts(0x80, pitch, velocity) }
      end

      def at time, block
        @scheduler.at(time) { block.call }
      end

    end
  end
end

