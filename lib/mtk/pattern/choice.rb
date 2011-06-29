module MTK
  module Pattern

    # Randomly choose from a list of elements
    class Choice < AbstractPattern

      #####################
      protected

      # (see AbstractPattern#current)
      def current
        @elements[ rand @elements.length ]
      end

    end

  end
end
