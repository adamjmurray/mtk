module MTK
  module Pattern

    # A {Cycle} of pitch-related elements, which may be {Pitch}es, {PitchClass}es, {PitchSet}s, or {Intervals} (Numeric)
    class PitchCycle < Cycle

      protected

      # extend value_of to handle intervals and PitchClasses
      def value_of element
        element = super # eval Procs
        case element
          when Numeric then @value + element if @value # add interval
          when PitchClass then @value.nearest(element) if @value
          else element
        end
      end

    end

  end
end
