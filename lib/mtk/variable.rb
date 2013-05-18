module MTK

  # A placeholder element for a variable value, for use within a {Patterns::Pattern} such as a {Patterns::ForEach} pattern.
  # Will be evaluated to an actual value by the Pattern or Sequencer
  #
  class Variable

    attr_reader :name

    attr_accessor :value

    def initialize name, value=nil
      @name = name
      @value = value
      @implicit = !!(name =~ /^\$+$/)
    end

    # @return true when this variable has no specific value and references the implicit variable stack (such as in a {Patterns::ForEach})
    def implicit?
      @implicit
    end

    def == other
      other.is_a? self.class and other.name == self.name
    end
  end

end
