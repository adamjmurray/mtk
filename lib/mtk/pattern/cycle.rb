module MTK
  module Pattern

    # An endless enumerator that outputs an element one at a time from a list of elements,
    # looping back to the beginning when elements run out.
    class Cycle < AbstractPattern

      # The number of cycles emitted (1 cycle == all elements emitted) since the last {#rewind}
      attr_reader :cycle_count
      
      # The maximum number of cycles this Pattern will emit before a StopIteration exception
      attr_reader :max_cycles

      def initialize(elements, options={})
        super
        @max_cycles = options[:max_cycles]
      end

      # Reset the sequence to the beginning
      def rewind
        @index = -1
        @cycle_count = 0
        super
      end

      ###################
      protected

      # (see AbstractPattern#advance!)
      def advance!
        super # base advance!() implementation prevents infinite loops with empty patterns
        @index += 1
        if @index >= @elements.length
          @cycle_count += 1
          if @max_cycles and @cycle_count >= @max_cycles
            raise StopIteration
          end
          @index = -1
          advance!
        end
      end

      # (see AbstractPattern#current)
      def current
        @elements[@index]
      end

    end

  end
end
