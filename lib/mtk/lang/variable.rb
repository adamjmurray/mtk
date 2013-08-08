module MTK
  module Lang

    # A placeholder element for a variable value, for use within a {Patterns::Pattern} such as a {Patterns::ForEach} pattern.
    # Will be evaluated to an actual value by the Pattern or Sequencer
    #
    class Variable

      ARPEGGIO = :'$ARPEGGIO'

      def self.define_arpeggio pitch_group
        new(ARPEGGIO, pitch_group)
      end


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

      # @return true if this variable represents the pitches of the arpeggio,
      # in which case the {#value} is a {Groups:PitchGroup}
      def arpeggio?
        @name == ARPEGGIO
      end

      # @return true if this variable represents one note of an arpeggio,
      # in which case the {#value} is the index of the pitch in the arpeggio {Groups:PitchGroup}
      def arpeggio_index?
        !!(name =~ /^\$-?\d+$/)
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
