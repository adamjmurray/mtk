module MTK
  module Patterns

    # For each value in the first sub-pattern, iterate over the second sub-pattern and chain the resulting values.
    #
    class ForEach < Pattern

      # (see Pattern#next)
      def next
        @index = 0 if @index < 0

        last_index = @elements.length-1
        while @index <= last_index
          # assume all elements are Patterns, otherwise this construct doesn't really have a point...
          pattern = @elements[@index]
          begin
            element = pattern.next
            value = evaluate_variables(element)

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
              pattern.rewind
              @vars.pop
              @index -= 1
            end
          end
        end
      end


      ###################
      protected

      # (see Pattern#rewind_or_cycle)
      def rewind_or_cycle(is_cycling=false)
        @vars = []
        @elements.each{|elem| elem.rewind }
        super
      end


      ####################
      private

      def evaluate_variables(element)
        case element
          when ::MTK::Variable
            if element.implicit?
              return @vars[-element.name.length] # '$' is most recently pushed value, $$' goes back 2 levels, '$$$' goes back 3, etc
            end
          when Array
            return element.map{|e| evaluate_variables(e) }
        end
        return element
      end

    end

  end
end
