module MTK
  module Lang

    # An object that modifies the interpretation of a {Patterns::Pattern}.
    class Modifier

      attr_reader :type, :value

      def initialize(type, value=nil)
        @type = type
        @value = value
      end

      #def locked?
      #  false
      #end

      def octave?
        @type == :octave
      end

      def force_rest?
        @type == :force_rest
      end

      def skip?
        @type == :skip
      end

      def == other
        other.is_a? self.class and other.type == @type and other.value == @value
      end

    end

  end
end