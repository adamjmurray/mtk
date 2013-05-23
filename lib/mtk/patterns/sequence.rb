module MTK
  module Patterns

    # A finite list of elements, which can be enumerated one at a time.
    class Sequence < Pattern

      ###################
      protected

      # (see Pattern#advance)
      def advance
        @index += 1
        raise StopIteration if @index >= @elements.length
        @current = @elements[@index]
      end

    end

  end
end
