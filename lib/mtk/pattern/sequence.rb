module MTK
  module Pattern

    # A finite list of elements, which can be enumerated one at a time.
    class Sequence < AbstractPattern
      include Collection

      # Reset the sequence to the beginning
      def rewind
        @index = -1
        super
      end

      ###################
      protected

      def advance!
        @index += 1
        raise StopIteration if @elements.nil? or @index >= @elements.length
      end

      def current
        @elements[@index]
      end
    end

    def Sequence(*anything)
      Sequence.new(anything)
    end
    module_function :Sequence

  end
end
