module MTK
  module Pattern

    # An arbitrary function that dynamically generates elements.
    #
    class Function < AbstractPattern

      def initialize(elements, options={})
        # unpack from the varargs array that may be passed in from the "convenience constructor methods" defined in MTK::Pattern
        elements = elements.first if elements.is_a? Enumerable
        super
      end

      # Reset the sequence to the beginning
      def rewind
        @prev = nil
        super
      end

      ###################
      protected

      # (see AbstractPattern#advance!)
      def advance!
        raise StopIteration if @elements.nil?
      end

      # (see AbstractPattern#current)
      def current
        @prev = case elements.arity
          when 0 then elements.call
          when 1 then elements.call(@prev)
          else elements.call(@prev, @element_count)
          # @element_count doesn't get incremented until the element is emitted, so the 2 arg call is like a "_with_index" block
        end
      end

    end

  end
end
