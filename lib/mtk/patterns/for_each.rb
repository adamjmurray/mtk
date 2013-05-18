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
        @index = 0
        @vars = []
        @elements.each{|elem| elem.rewind }
        super
      end

      def next
        # going to assume all elements are Patterns, otherwise this construct doesn't really have a point...
        len = @elements.length
        while @index < len
          elem = @elements[@index]
          is_last = (@index == len-1)

          begin
            value = elem.next
            if value.is_a? ::MTK::Variable
              # for now, just assume all vars are '$'
              value = @vars[-1] # TODO: use number of $'s? Like in CoSy...
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

      ###################
      protected


      # (see Pattern#current)
      def current
        @current
      end

    end

  end
end
