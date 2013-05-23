module MTK
  module Patterns

    # For each value in the first sub-pattern, iterate over the second sub-pattern and chain the resulting values.
    #
    class ForEach < Pattern

      # @param (see Pattern#initialize)
      # @option (see Pattern#initialize)
      def initialize(elements, options={})
        super
      end

      # (see Pattern#rewind)
      def rewind
        super
        @index = 0 # TODO: why the inconsistency with base Pattern?
        @vars = []
        @elements.each{|elem| elem.rewind }
        self
      end

      def next
        # going to assume all elements are Patterns, otherwise this construct doesn't really have a point...
        len = @elements.length
        while @index < len
          elem = @elements[@index]
          is_last = (@index == len-1)

          begin
            value = elem.next

            # evaluate variables
            if value.is_a? ::MTK::Variable
              if value.implicit?
                value = @vars[-value.name.length] # '$' is most recently pushed value, $$' goes back 2 levels, '$$$' goes back 3, etc
              end
            end

            if is_last # then emit values
              @current = value
              return emit(value)

            else # not last element, so store variables
              @vars.push value
              @index += 1
            end

          rescue StopIteration
            if @index==0
              raise # We're done when the first pattern is done
            else
              elem.rewind
              @vars.pop
              @index -= 1
            end
          end
        end
      end

    end

  end
end
