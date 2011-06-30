module MTK
  module Pattern

    # A finite list of elements, which can be enumerated one at a time.
    class Sequence < AbstractPattern

      # Reset the sequence to the beginning
      def rewind
        @index = -1
        super
      end

      ###################
      protected

      # (see AbstractPattern#advance!)
      def advance!
        super
        @index += 1
        raise StopIteration if @index >= @elements.length
      end

      # (see AbstractPattern#current)
      def current
        @elements[@index]
      end
    end

  end
end
