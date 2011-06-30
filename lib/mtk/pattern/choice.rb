module MTK
  module Pattern

    # Randomly choose from a list of elements
    class Choice < AbstractPattern

      def initialize(elements, options={})
        super
        @weights = options.fetch :weights, Array.new(@elements.length, 1)
        @total_weight = @weights.inject(:+).to_f
      end

      #####################
      protected

      # (see AbstractPattern#current)
      def current
        target = rand * @total_weight
        @weights.each_with_index do |weight,index|
          return @elements[index] if target < weight
          target -= weight
        end
      end

    end

  end
end
