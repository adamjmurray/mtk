module MTK
  module Helper

    module Convert

      def to_pitch_classes(*anything)
        anything = anything.first if anything.length == 1
        if anything.respond_to? :to_pitch_classes
          anything.to_pitch_classes
        else
          case anything
            when Enumerable then anything.map{|item| PitchClass(item) }
            else [PitchClass(anything)]
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
            when Enumerable then anything.map{|item| Pitch(item) }
            else [Pitch(anything)]
          end
        end
      end
      module_function :to_pitches

    end

  end
end