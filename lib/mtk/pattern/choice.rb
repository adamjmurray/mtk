module MTK
  module Pattern

    # An element enumerator that randomly choices from a list of elements
    class Choice < AbstractPattern

      #####################
      protected

      def current
        @elements[ rand @elements.length ]
      end

    end

  end
end
