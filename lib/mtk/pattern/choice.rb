module MTK
  module Pattern

    # An element enumerator that randomly choices from a list of elements
    class Choice

      # The element choices
      attr_reader :elements

      def initialize(elements)
        @elements = elements
      end

      def next
        @elements[rand(@elements.length)] if @elements and not @elements.empty?
      end

    end

  end
end
