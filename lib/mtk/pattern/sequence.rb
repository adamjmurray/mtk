module MTK
  module Pattern

    # An endless enumerator that outputs an element one at a time from a list of elements,
    # looping back to the beginning when elements run out.
    class Sequence

      # The list of elements enumerated by this Sequence
      attr_reader :elements

      # @param elements [Array] the list of {#elements}
      # @param default [Object] the default value returned by {#next} in place of nil
      def initialize(elements, default=nil)
        @elements, @default = elements, default
        reset
      end

      # reset the Sequence to its initial state
      def reset
        @index = -1
        @last_element = nil
        @last_value = nil
      end

      # The value of the next element in the Sequence.
      # The sequence goes back to the first element if there are no more elements.
      #
      # @return if an element is a Proc, it is called (depending on the arity of the Proc: with either no arguments,
      #   the last value of #next, or the last value and last element) and its return value is returned.
      # @return if an element is nil, previous value of #next is returned. If there is no previous value the @default is returned.
      # @return otherwise the element itself is returned
      #
      def next
        if @elements and not @elements.empty?
          @index = (@index + 1) % @elements.length
          element = @elements[@index]

          value = case element
            when Proc
              case element.arity
                when 0 then element.call
                when 1 then element.call(@last_value)
                else element.call(@last_value, @last_element)
              end
            when nil then @last_value
            else element
          end

          @last_element, @last_value = element, value
        end
        @last_value ||= @default
      end
    end

  end
end
