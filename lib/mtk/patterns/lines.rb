module MTK
  module Patterns

    # A piecewise linear function (see {http://en.wikipedia.org/wiki/File:PiecewiseLinear.png}) defined in terms
    # of [value, steps_to_reach_value] pairs.
    #
    # The "steps_to_reach_value" for the first element is ignored and may be omitted, since it takes 0 steps to start.
    class Lines < Pattern

      ###################
      protected

      # (see Pattern#rewind_or_cycle)
      def rewind_or_cycle(is_cycling=false)
        @steps = -1
        @step_count = -1
        @prev = nil
        @next = nil
        super
      end

      # (see Pattern#advance)
      def advance
        while @step_count >= @steps
          @step_count = 0

          @index += 1
          raise StopIteration if @index >= @elements.length

          @prev = @next
          next_elem = @elements[@index]
          if next_elem.is_a? Array
            @next = next_elem.first
            @steps = next_elem.last.to_f
          else
            @next = next_elem
            @steps = 1.0
          end
        end

        @step_count += 1

        if @prev and @next
          # linear interpolation
          @current = @prev + (@next - @prev)*@step_count/@steps
        else
          @current = @next
        end
      end

    end

  end
end
