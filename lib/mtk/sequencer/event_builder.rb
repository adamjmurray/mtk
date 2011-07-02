module MTK
  module Sequencer

    # A helper class for {Sequencer}s.
    # Takes a list of patterns and constructs a list of {Events}s from the next elements in each pattern.
    class EventBuilder

      def initialize(options={})
        @default_pitch = options.fetch :default_pitch, Pitches::C4
        @default_intensity = options.fetch :default_intensity, Dynamics::mf
        @default_duration = options.fetch :default_duration, 1
      end

      def next_events(patterns)
        pitches = []
        intensity = @default_intensity
        duration = @default_duration

        for pattern in patterns
          element = pattern.next
          case element
            when Pitch then pitches << element
            when PitchSet then pitches += element.pitches
            else case pattern.type
              when :intensity then intensity = element
              when :duration then duration = element
            end
          end
        end

        pitches.map{|pitch| Note(pitch,intensity,duration) } if not pitches.empty?
      end

    end

  end
end
