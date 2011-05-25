module MTK
  module Pattern

    # An endless enumerator that outputs an element one at a time from a list of elements,
    # looping back to the beginning when elements run out.
    class Sequence

      # The list of elements enumerated by this Sequence
      attr_reader :elements

      # @param elements [Array] the list of {#elements}
      # @param default [Object] the default value returned by {#next} in place of nil
      def initialize(elements)
        if elements.respond_to? :elements
          @elements = elements.elements
        else
          @elements = elements.to_a
        end
        reset
      end

      # reset the Sequence to its initial state
      def reset
        @index = -1
        @element = nil
        @value = nil
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
          value = value_of(element)
          @element, @value = element, value
        end
        @value
      end

      ####################
      protected

      def value_of element
        case element
          when Proc
            case element.arity
              when 0 then element.call
              when 1 then element.call(@value)
              else element.call(@value, @element)
            end
          else element
        end
      end

    end

  end
end
