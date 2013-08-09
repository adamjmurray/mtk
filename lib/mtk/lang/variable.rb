module MTK
  module Lang

    # A placeholder element for a variable value, for use within a {Patterns::Pattern} such as a {Patterns::ForEach} pattern.
    # Will be evaluated to an actual value by the Pattern or Sequencer
    #
    class Variable

      ARPEGGIO = :arpeggio
      ARPEGGIO_ELEMENT = :arpeggio_element
      FOR_EACH = :for_each
      USER_DEFINED =:user_defined

      attr_reader :type, :name

      attr_accessor :value


      def initialize type, name, value=nil
        @type = type
        @name = name
        @value = value
      end


      # @return true if this variable represents the pitches of the arpeggio,
      # in which case the {#value} is a {Groups:PitchGroup}
      def arpeggio?
        @type == ARPEGGIO
      end

      # @return true if this variable represents one element of an arpeggio,
      # in which case the {#value} is the index of the pitch in the arpeggio {Groups:PitchGroup}
      def arpeggio_element?
        @type == ARPEGGIO_ELEMENT
      end

      # true when this represent a variable on the {Patterns::ForEach} stack
      # if true, the {#value} represents the index from the top of the for each variable stack
      def for_each?
        @type == FOR_EACH
      end

      def user_defined?
        @type == USER_DEFINED
      end


      def == other
        other.is_a? self.class and other.type == self.type and other.name == self.name and other.value == self.value
      end

      def to_s
        "#{self.class}<#{@type} #{@name}#{'='+@value.inspect}>"
      end
    end

  end
end
