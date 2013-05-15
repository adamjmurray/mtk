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
        @index = -1
        @vars = []
        super
      end

      def next
        # going to assume all elements are Patterns, otherwise this construct doesn't really have a point...

        if @index < 0
          @index = 0
          elem = @elements[0]
          elem.rewind
          @vars.push elem.next
          @index = 1
        end

        # TODO: generalize to handle more than 2 patterns
        loop do
          elem = @elements[1]
          begin
            @current = elem.next
            if @current.is_a? ::MTK::Variable
              # for now, just assume '$'
              @current = @vars[-1] # TODO: use number of $'s? Like in CoSy...
            end
            return emit(@current)
          rescue StopIteration
            @elements[1].rewind
            @vars.pop
            @vars.push @elements[0].next # when elements[0].next raises StopIteration, we are done
          end
        end
        raise StopIteration
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
