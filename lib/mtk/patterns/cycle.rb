module MTK
  module Patterns

    # An endless enumerator that outputs an element one at a time from a list of elements,
    # looping back to the beginning when elements run out.
    # This is the same as a Sequence but by default has unlimited @max_cycles
    class Cycle < Sequence

      def initialize(elements, options={})
        super
        # Base Pattern & Sequence default to 1 max_cycle, this defaults to nil which is unlimited cycles
        @max_cycles = options[:max_cycles]
      end

    end

  end
end
