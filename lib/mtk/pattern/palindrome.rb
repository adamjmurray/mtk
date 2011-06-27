module MTK
  module Pattern

    # An endless enumerator that outputs an element one at a time from a list of elements,
    # looping back to the beginning when elements run out.
    class Palindrome < Cycle

      def rewind
        @direction = 1
        super
      end

      ##############
      protected

      def repeat_ends?
        @repeat_ends ||= @options.fetch :repeat_ends, false
      end

      def advance!
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
      end

    end

  end
end
