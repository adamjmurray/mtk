module MTK
  module Patterns

    # A pattern of elements that can be emitted one element at a time via calls to {#next}.
    #
    # Patterns can be reset to the beginning via {#rewind}.
    #
    # @abstract Subclass and override {#advance!} and {#current} to implement a Pattern.
    #
    class Pattern
      include MTK::Helpers::Collection

      # The elements in the pattern
      attr_reader :elements

      attr_reader :options

      # The type of elements in the pattern, such as :pitch, :intensity, or :duration
      #
      # This is often needed by {Sequencers::Sequencer} classes to interpret the pattern elements.
      attr_reader :type

      # The number of elements emitted since the last {#rewind}
      attr_reader :element_count
      
      # The maximum number of elements this Pattern will emit before a StopIteration exception
      attr_reader :max_elements

      # @param elements [Enumerable] the list of elements in the pattern
      # @param options [Hash] the pattern options
      # @option options [String] :type the pattern {#type}
      # @option options [Fixnum] :max_elements the {#max_elements}
      def initialize(elements, options={})
        elements = elements.to_a if elements.is_a? Enumerable
        @elements = elements
        @options = options
        @type = options[:type]
        @max_elements = options[:max_elements]
        rewind
      end

      # Construct a pattern from an Array.
      # @param (see #initialize)
      # @option (see #initialize)
      # @see #initialize
      def self.from_a(elements, options={})
        new(elements, options)
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
        if @current.kind_of? Pattern
          begin
            subpattern_next = @current.next
            subpattern_has_next = true
          rescue StopIteration
            subpattern_has_next = false
          end

          return emit subpattern_next if subpattern_has_next
          # else fall through and continue with normal behavior
        end

        begin
          advance!
        rescue StopIteration
          @current = nil
          raise
        end

        @current = current
        if @current.kind_of? Pattern
          @current.rewind # start over, in case we already enumerated this element and then did a rewind
          return self.next
        end

        emit @current
      end


      ##################
      protected

      # Update internal state (index, etc) so that {#current} will refer to the next element.
      # @raise StopIteration if there are no more elements
      def advance!
        raise StopIteration if @elements.nil? or @elements.empty?
      end

      # The current element in the pattern, which will be returned by {#next} (after a call to {#advance!}).
      def current
        @elements[0]
      end


      ##################
      private

      def emit element
        @element_count += 1
        raise StopIteration if @max_elements and @element_count > @max_elements
        element
      end

      def self.inherited(subclass)
        # Define a convenience method like MTK::Patterns.Sequence()
        # that can handle varargs or a single array argument, plus any Hash options
        classname = subclass.name.sub /.*::/, '' # Strip off module prefixes
        MTK::Patterns.define_singleton_method classname do |*args|
          options  = (args[-1].is_a? Hash) ? args.pop : {}
          args = args[0] if args.length == 1 and args[0].is_a? Array
          subclass.new(args,options)
        end

        %w(Pitch PitchClass Intensity Duration Interval Rhythm).each do |type|
          MTK::Patterns.define_singleton_method "#{type}#{classname}" do |*args|
            options  = (args[-1].is_a? Hash) ? args.pop : {}
            args = args[0] if args.length == 1 and args[0].is_a? Array
            options[:type] = type.downcase.to_sym
            # TODO: coerce each arg to the type
            # Note: Rhythm is a special case, needs to coerce to Duration.
            # We almost don't need to set options[:type], anymore, except it's needed by the RhythmSequencer
            subclass.new(args,options)
          end
        end
      end
    end

  end
end
