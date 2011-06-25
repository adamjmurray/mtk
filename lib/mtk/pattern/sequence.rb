module MTK
  module Pattern

    # A finite list of elements, which can be enumerated one at a time.
    class Sequence
      include Collection
      include Enumerator

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
        if @current.is_a? Enumerator
          begin
            return @current.next
          rescue StopIteration
            # fall through and proceed with normal behavior
          end
        end
        @index += 1
        if @elements.nil? or @index >= @elements.length
          @current = nil
          raise StopIteration
        else
          @current = @elements[@index]
          if @current.is_a? Enumerator
            @current.rewind # start over, in case we already enumerated this element and then did a rewind
            self.next
          else
            @current
          end
        end
      end

      # Reset the sequence to the beginning
      def rewind
        @index = -1
        @current = nil
        self
      end
    end

    def Sequence(*anything)
      Sequence.new(anything)
    end
    module_function :Sequence

  end
end
