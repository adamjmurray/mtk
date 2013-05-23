module MTK
  module Patterns

    # For each value in the first sub-pattern, iterate over the second sub-pattern and chain the resulting values.
    #
    class ForEach < Pattern

      # (see Pattern#rewind)
      def rewind(is_cycling=false)
        @vars = []
        @elements.each{|elem| elem.rewind }
        super
      end


      # (see Pattern#next)
      def next
        @index = 0 if @index < 0

        last_index = @elements.length-1
        while @index <= last_index
          elem = @elements[@index]
          begin
            # assume all elements are Patterns, otherwise this construct doesn't really have a point...
            value = elem.next

            # evaluate variables
            if value.is_a? ::MTK::Variable
              if value.implicit?
                value = @vars[-value.name.length] # '$' is most recently pushed value, $$' goes back 2 levels, '$$$' goes back 3, etc
              end
            end

            if @index == last_index # then emit values
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
