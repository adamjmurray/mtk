module MTK
  module Patterns

    # An endless enumerator that outputs an element one at a time from a list of elements,
    # looping back to the beginning when elements run out.
    class Cycle < Pattern


      def initialize(elements, options={})
        super
        @max_cycles = options[:max_cycles] # TODO: default to 1 to avoid accidental infinite loops
      end

      ###################
      protected

      # (see Pattern#advance!)
      def advance!
        @index += 1
        raise StopIteration if @index >= @elements.length
        @current = @elements[@index]
      end

    end

  end
end
