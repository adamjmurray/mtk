module MTK
  module Lang

    # An object that modifies the interpretation of a {Patterns::Pattern}.
    class Modifier

      attr_reader :type

      def initialize(type)
        @type = type
      end

      def force_rest?
        @type == :force_rest
      end

      def == other
        other.is_a? self.class and other.type == @type
      end

    end

  end
end