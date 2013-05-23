module MTK
  module Patterns

    # An endless enumerator that outputs an element one at a time from a list of elements,
    # looping back to the beginning when elements run out.
    class Palindrome < Cycle

      # true if the first/last element are repeated when the ends are reached, else false
      def repeat_ends?
        @repeat_ends ||= @options.fetch :repeat_ends, false
      end

      ##############
      protected

      # (see Pattern#rewind_or_cycle)
      def rewind_or_cycle(is_cycling=false)
        @direction = 1
        super
      end

      # (see Pattern#advance)
      def advance
        raise StopIteration if @elements.nil? or @elements.empty? # prevent infinite loops

        @index += @direction

        if @index >= @elements.length
          @direction = -1
          @index = @elements.length - 1
          @index -= 1 unless repeat_ends? or @elements.length == 1

        elsif @index < 0
          @direction = 1
          @index = 0
          @index += 1 unless repeat_ends? or @elements.length == 1
        end

        @current = @elements[@index]
      end

    end

  end
end
