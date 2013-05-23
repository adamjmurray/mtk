module MTK
  module Patterns

    # An arbitrary function that dynamically generates elements.
    #
    class Function < Pattern

      attr_reader :function
      
      def initialize(elements, options={})
        # unpack from the varargs Array that may be passed in from the "convenience constructor methods" defined in MTK::Pattern                        \
        @function = if elements.is_a? Enumerable then elements.first else elements end
        super [@function], options
      end


      ###################
      protected

      # (see Pattern#rewind_or_cycle)
      def rewind_or_cycle(is_cycling=false)
        @function_call_count = -1
        super
      end

      def advance
        @function_call_count += 1
        @current = case @function.arity
          when 0 then @function.call
          when 1 then @function.call(@current)
          when 2 then @function.call(@current, @function_call_count)
          else @function.call(@current, @function_call_count, @element_count)
        end
      end

    end

  end
end
