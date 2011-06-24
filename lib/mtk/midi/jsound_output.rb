require 'rubygems'
require 'jsound'
require 'gamelan'

module MTK
  module MIDI

    # Provides MIDI output for JRuby via the jsound gem
    class JSoundOutput

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
                puts "Scheduling #{pitch}, #{velocity} @ #{time}"
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
      # Otherwise when the @generator methods are called, they might not be passed the values you expected.
      # I have suspect this may not a problem in MRI ruby, but I'm having trouble in JRuby
      # (pitch and velocity were always the last scheduled values)

      def note_on(pitch, velocity)
        lambda { puts "Running #{pitch}, #{velocity}"; @generator.note_on(pitch, velocity) }
      end

      def note_off(pitch, velocity)
        lambda { @generator.note_off(pitch, velocity) }
      end

      def at time, block
        @scheduler.at(time) { block.call }
      end

    end
  end
end

