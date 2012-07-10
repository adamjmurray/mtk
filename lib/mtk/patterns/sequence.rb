module MTK
  module Patterns

    # A finite list of elements, which can be enumerated one at a time.
    class Sequence < Pattern

      # Reset the sequence to the beginning
      def rewind
        @index = -1
        super
      end

      ###################
      protected

      # (see Pattern#advance!)
      def advance!
        super
        @index += 1
        raise StopIteration if @index >= @elements.length
      end

      # (see Pattern#current)
      def current
        @elements[@index]
      end
    end

  end
end
