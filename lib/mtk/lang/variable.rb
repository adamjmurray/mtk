module MTK
  module Lang

    # A placeholder element for a variable value, for use within a {Patterns::Pattern} such as a {Patterns::ForEach} pattern.
    # Will be evaluated to an actual value by the Pattern or Sequencer
    #
    class Variable

      attr_reader :name

      attr_accessor :value

      def initialize name, value=nil
        @name = name
        @value = value
      end

      # @return true when this variable has no specific value and references the implicit variable stack (such as in a {Patterns::ForEach})
      def implicit?
        @implicit ||= !!(name =~ /^\$+$/)
      end

      # @return true if this variable represents a scale step, in which case the {#value} is the scale step number
      # @see MTK::Groups::Scale
      def scale_step?
        @scale_step ||= !!(name =~ /^\$\d+$/)
      end

      def == other
        other.is_a? self.class and other.name == self.name
      end

      def to_s
        "#{self.class}<#{name}#{'='+value.to_s if value}>"
      end
    end

  end
end
