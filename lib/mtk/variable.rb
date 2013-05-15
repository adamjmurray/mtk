module MTK

  # A placeholder element for a variable value, for use within a {Pattern} such as a {ForEach} pattern.
  # Will be evaluated to an actual value by the Pattern or Sequencer
  #
  class Variable

    attr_accessor :name

    def initialize name
      @name = name
    end

    def == other
      other.is_a? self.class and other.name == self.name
    end
  end

end
