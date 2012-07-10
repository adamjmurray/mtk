module MTK
  module Patterns

    # The core interface for all Patterns.
    #
    # This module doesn't provide any useful default functionality.
    # It only indicates that a class is compatible with MTK's pattern enumerator interface.
    #
    module Enumerator

      # Return the next element in the enumerator
      # @raise StopIteration when no more elements are available
      def next
        raise StopIteration
      end

      # Reset the enumerator to the beginning
      # @return self
      def rewind
        self
      end

    end

  end
end
