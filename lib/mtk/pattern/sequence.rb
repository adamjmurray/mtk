module MTK
  module Pattern

    # A finite list of elements, which can be enumerated one at a time.
    class Sequence
      include Collection

      attr_reader :elements
      
      def initialize(elements)
        @elements = elements
        rewind
      end

      def self.from_a(enumerable)
        new(enumerable)
      end

      # Return the next value in the sequence
      def next
        @index += 1
        raise StopIteration if @elements.nil? or @index >= @elements.length
        @elements[@index]
      end

      # Reset the sequence to the beginning
      def rewind
        @index = -1
      end
    end

    def Sequence(*anything)
      Sequence.new(anything)
    end
    module_function :Sequence

  end
end
