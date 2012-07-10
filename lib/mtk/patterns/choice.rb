module MTK
  module Patterns

    # Randomly choose from a list of elements.
    #
    # Supports giving different weights to different choices.
    # Default is to weight all choices equally.
    #
    class Choice < Pattern

      # @param (see Pattern#initialize)
      # @option (see Pattern#initialize)
      # @option options [Array] :weights a list of chances that each corresponding element will be selected (normalized against the total weight)
      # @example choose the second element twice as often as the first or third:
      #     MTK::Pattern::Choice.new [:first,:second,:third], :weights => [1,2,1]
      def initialize(elements, options={})
        super
        @weights = options.fetch :weights, Array.new(@elements.length, 1)
        @total_weight = @weights.inject(:+).to_f
      end

      #####################
      protected

      # (see Pattern#current)
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
