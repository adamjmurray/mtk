module MTK
  module Patterns

    # A pattern that takes a list of patterns and combines their values into a list of event properties.
    class Chain < Pattern

      def initialize(elements, options={})
        super
        @stop_after_first = true # assume everything's an element until we inspect them in the loop below
        @stop_after_first = true if @elements.all?{|element| not element.is_a? ::MTK::Patterns::Pattern }
      end

      ###################
      protected

      # (see Pattern#rewind_or_cycle)
      def rewind_or_cycle(is_cycling=false)
        @is_element_done = Array.new(elements.size)
        super
      end

      # (see Pattern#advance)
      def advance
        @current = @elements.map.with_index do |element,index|
          if element.is_a? ::MTK::Patterns::Pattern
            begin
              element.next
            rescue StopIteration
              raise StopIteration if element.max_elements_exceeded?
              @is_element_done[index] = true
              element.rewind
              element.next
            end
          else
            element
          end
        end

        raise StopIteration if @is_element_done.all?{|done| done }

        @elements.each.with_index do |element,index|
          @is_element_done[index] = true unless element.is_a? ::MTK::Patterns::Pattern
        end
      end

    end

  end
end
