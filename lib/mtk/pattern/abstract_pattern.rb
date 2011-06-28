module MTK
  module Pattern

    # A pattern of elements that can be emitted one element at a time.
    #
    # @abstract subclass and override {#advance!} and {#current} to implement a Pattern
    #
    class AbstractPattern
      include Enumerator

      # The elements in the pattern
      attr_reader :elements

      # The type of elements in the pattern, such as :pitch, :intensity, or :duration
      #
      # This is often needed by {Sequencer} classes to interpret the pattern elements.
      attr_reader :type

      # The number of elements emitted since the last {#rewind}
      attr_reader :element_count
      
      # The maximum number of elements this Pattern will emit before a StopIteration exception
      attr_reader :max_elements

      # @param elements [Array] the list of elements in the pattern
      # @param options [Hash] the pattern options
      # @option options [String] :type the pattern {#type}
      # @option options [Fixnum] :max_elements the {#max_elements}
      def initialize(elements, options={})
        @elements = elements
        @options = options
        @type = options[:type]
        @max_elements = options[:max_elements]
        rewind
      end

      # Construct a pattern from an Array.
      # @param elements [Array] the list of elements in the pattern
      # @see #initialize
      def self.from_a(elements)
        new(elements.to_a)
      end

      # Reset the pattern to the beginning
      def rewind
        @current = nil
        @element_count = 0
        self
      end

      # Emit the next element in the pattern
      # @raise StopIteration when the pattern has emitted all values, or has hit the {#max_elements} limit.
      def next
        if @current.is_a? Enumerator
          subpattern_has_next = true
          begin
            subpattern_next = @current.next
          rescue StopIteration
            subpattern_has_next = false
          end
          if subpattern_has_next
            increment_element_count!
            return subpattern_next
          end
          # else fall through and continue with normal behavior
        end

        begin
          advance!
        rescue StopIteration
          @current = nil
          raise
        end

        @current = current
        if @current.is_a? Enumerator
          @current.rewind # start over, in case we already enumerated this element and then did a rewind
          return self.next
        end

        increment_element_count!
        @current
      end


      ##################
      protected

      def advance!
        raise StopIteration if @elements.nil? or @elements.empty?
      end

      def current
        @elements
      end


      ##################
      private

      def increment_element_count!
        @element_count += 1
        raise StopIteration if @max_elements and @element_count > @max_elements
      end
    end

  end
end
