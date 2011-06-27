module MTK
  module Pattern

    # A finite list of elements, which can be enumerated one at a time.
    class AbstractPattern
      include Enumerator

      attr_reader :elements

      def initialize(elements, options={})
        @elements = elements
        @options = options
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
            # continue on and advance
          end
        end

        begin
          advance!
        rescue StopIteration
          @current = nil
          raise
        end

        @current = current
        if @current.is_a? Enumerator
          @current.rewind # start over, in case we already enumerated this element and then did a rewind
          return self.next
        end

        @current
      end

      # Reset the sequence to the beginning
      def rewind
        @current = nil
        self
      end

      ##################
      protected
      def advance!
        raise StopIteration if @elements.nil? or @elements.empty?
      end

      def current
        @elements
      end
    end

    def Sequence(*anything)
      Sequence.new(anything)
    end
    module_function :Sequence

  end
end
