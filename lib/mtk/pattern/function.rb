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
        @function_call_count = -1
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
        @function_call_count += 1
        @prev = case elements.arity
          when 0 then elements.call
          when 1 then elements.call(@prev)
          when 2 then elements.call(@prev, @function_call_count)
          else elements.call(@prev, @function_call_count, @element_count)
        end
      end

    end

  end
end
