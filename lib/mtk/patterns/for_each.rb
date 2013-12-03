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
          when ::MTK::Lang::Variable
            if element.for_each_element?
              raise "Invalid attempt to access for each variable before any were defined" if @vars.empty?

              case element.name
                when :index
                  index = -(element.value + 1) # for each index value 0 means the last element (-1), index 1 means second-to last (-2), etc
                  return @vars[index]

                when :random
                  return @vars[rand*@vars.length]

                when :all
                  return @vars

                else raise "Invalid for each variable name #{element.name}"
              end
            end

          when Array
            return element.map{|e| evaluate_variables(e) }

        end

        element
      end

    end

  end
end
