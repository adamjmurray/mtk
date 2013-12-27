module MTK
  module Lang

    # An object that modifies the interpretation of a specific element in {Patterns::Pattern}.
    class ModifiedElement

      attr_reader :modifier, :element
      
      def initialize(modifier, element)
        @modifier = modifier
        @element = element
      end

      def == other
        other.is_a? self.class and other.modifier == @modifier and other.element == @element
      end
    end
  end
end