module MTK
  module Helpers

    module Convert

      def to_pitch_classes(*anything)
        anything = anything.first if anything.length == 1
        if anything.respond_to? :to_pitch_classes
          anything.to_pitch_classes
        else
          case anything
            when ::Enumerable then anything.map{|item| MTK::PitchClass(item) }
            else [MTK::PitchClass(anything)]
          end
        end
      end
      module_function :to_pitch_classes


      def to_pitches(*anything)
        anything = anything.first if anything.length == 1
        if anything.respond_to? :to_pitches
          anything.to_pitches
        else
          case anything
            when ::Enumerable then anything.map{|item| MTK::Pitch(item) }
            else [MTK::Pitch(anything)]
          end
        end
      end
      module_function :to_pitches

    end

  end
end