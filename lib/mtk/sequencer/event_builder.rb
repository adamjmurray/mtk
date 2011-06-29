module MTK
  module Sequencer

    # A helper class for {Sequencer}s.
    # Takes a list of patterns and constructs a list of {Events}s from the next elements in each pattern.
    class EventBuilder

      def self.next_events(patterns)
        pitches = []
        intensity = Dynamics::mf
        duration = 1

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
