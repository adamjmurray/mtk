module MTK
  module Pattern

    # An element enumerator that randomly choices from a list of elements
    class Choice < Sequence

      #####################
      protected

      def advance_index!
        raise StopIteration if @elements.nil? or @elements.empty?
      end

      def current
        @elements[ rand @elements.length ]
      end

    end

  end
end
