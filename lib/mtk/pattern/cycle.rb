module MTK
  module Pattern

    # An endless enumerator that outputs an element one at a time from a list of elements,
    # looping back to the beginning when elements run out.
    class Cycle < Sequence

      ##############
      protected

      def advance_index!
        raise StopIteration if @elements.nil? or @elements.empty? # prevent infinite loops
        begin
          super
        rescue StopIteration
          rewind
          super
        end
      end

    end

  end
end
