module MTK
  module Patterns

    # An arbitrary function that dynamically generates elements.
    #
    class Function < Pattern

      attr_reader :function
      
      def initialize(elements, options={})
        super
        @function = @elements
        # unpack from the varargs Array that may be passed in from the "convenience constructor methods" defined in MTK::Pattern                        \
        @function = @function.first if @function.is_a? Enumerable
      end
      
      # Reset the sequence to the beginning
      def rewind
        @prev = nil
        @function_call_count = -1
        super
      end

      ###################
      protected

      # (see Pattern#advance!)
      def advance!
        raise StopIteration if @elements.nil?
      end

      # (see Pattern#current)
      def current
        @function_call_count += 1
        @prev = case @function.arity
          when 0 then @function.call
          when 1 then @function.call(@prev)
          when 2 then @function.call(@prev, @function_call_count)
          else @function.call(@prev, @function_call_count, @element_count)
        end
      end

    end

  end
end
