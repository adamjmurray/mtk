module MTK
  module Sequencer

    # A helper class for {Sequencer}s.
    # NoteBuilder takes a list of elements (typically coming from {Pattern}s)
    # and constructs a list of {Note}s from the elements.
    #
    class EventBuilder

      def self.events_for(elements)
        pitches = []
        intensity = Dynamics::mf
        duration = 1

        for element in elements
          case element
            when Pitch then pitches << element
            when PitchSet then pitches += element.pitches
            else
              if element.respond_to? :mtk_type
                case element.mtk_type
                  when :intensity then intensity = element
                  when :duration then duration = element
                end
              end
          end
        end

        pitches.map{|pitch| Note(pitch,intensity,duration) } if not pitches.empty?
      end

    end

  end
end
