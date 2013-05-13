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
            return emit(subpattern_next)
          rescue StopIteration
            # fall through and continue with normal behavior
          end
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

      def max_elements_exceeded?
        @max_elements and @element_count >= @max_elements
      end

      def empty?
        @elements.nil? or @elements.empty?
      end

      ##################
      protected

      # Update internal state (index, etc) so that {#current} will refer to the next element.
      # @raise StopIteration if there are no more elements
      def advance!
        raise StopIteration if empty? or max_elements_exceeded?
      end

      # The current element in the pattern, which was returned by the last call to {#next}
      def current
        @elements[0]
      end


      ##################
      private

      def emit element
        @element_count += 1
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
            constructorForType = (type == 'Rhythm') ? 'Duration' : type
            args = args.map{|arg| (arg.nil? or arg.is_a? Proc) ? arg : MTK.send(constructorForType, arg) } # coerce to the given type (or Duration for rhythm type)
            subclass.new(args,options)
          end
        end
      end
    end

  end
end
