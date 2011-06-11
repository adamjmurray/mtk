module MTK
  module Pattern

    # A finite list of elements
    class Sequence
      include Collection

      attr_reader :elements
      
      def initialize(elements)
        @elements = elements
      end

      def self.from_a(enumerable)
        new(enumerable)
      end
    end

    def Sequence(*anything)
      Sequence.new(anything)
    end
    module_function :Sequence

  end
end
