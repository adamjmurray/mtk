module MTK

  # A measure of intensity, using an underlying value in the range 0.0-1.0
  class Intensity

    include Comparable

    # The names of the base intensities. See {}MTK::Constants::Intensities} for more info.
    NAMES = %w[ppp pp p mp mf o ff fff].freeze

    VALUES_BY_NAME = {
      'ppp' => 0.125,
      'pp' => 0.25,
      'p' => 0.375,
      'mp' => 0.5,
      'mf' => 0.625,
      'o' => 0.75,
      'ff' => 0.875,
      'fff' => 1.0
    }

    @flyweight = {}

    # The number of beats, typically representation as a Rational
    attr_reader :value

    def initialize(value)
      @value = value
    end

    # Return an Intensity, only constructing a new instance when not already in the flyweight cache
    def self.[](value)
      value = value.to_f
      #value = 0.0 if value < 0
      #value = 1.0 if value > 1
      @flyweight[value] ||= new(value)
    end

    class << self
      alias :from_f :[]
      alias :from_i :[]
    end

    # Lookup a duration by name.
    # This method supports appending any combination of '.' and 't' for more fine-grained values.
    # each '.' multiplies by 3/2, and each 't' multiplies by 2/3.
    # @example lookup value of 'q.' (eight note), which is 1.5 (1 * 1.5)
    #         MTK::Durations['q.']
    def self.from_s(s)
      return self[1.0] if s == 'fff+' # special case because "fff" is already the maximum

      name = nil
      modifier = nil
      if s =~ /^(\w+)([+-])?$/
        name = $1
        modifier = $2
      end

      value = VALUES_BY_NAME[name]
      raise ArgumentError.new("Invalid Intensity string '#{s}'") unless value

      value += 1.0/24 if modifier == '+'
      value -= 1.0/24 if modifier == '-'

      self[value]
    end

    class << self
      alias :from_name :from_s
    end

    # The number of beats as a floating point number
    def to_f
      @value.to_f
    end

    # The numerical value for the nearest whole number of beats
    def to_i
      @value.round
    end

    def to_midi
      (to_f * 127).round
    end

    def to_s
      @value.to_s
    end

    def inspect
      "#{self.class}<#{to_s}>"
    end

    def ==( other )
      other.is_a? MTK::Intensity and other.value == @value
    end

    def <=> other
      if other.respond_to? :value
        @value <=> other.value
      else
        @value <=> other
      end

    end

    def + intensity
      if intensity.is_a? MTK::Intensity
        MTK::Intensity[@value + intensity.value]
      else
        MTK::Intensity[@value + intensity]
      end
    end

    def -intensity
      if intensity.is_a? MTK::Intensity
        MTK::Intensity[@value - intensity.value]
      else
        MTK::Intensity[@value - intensity]
      end
    end

    def * intensity
      if intensity.is_a? MTK::Intensity
        MTK::Intensity[@value * intensity.value]
      else
        MTK::Intensity[@value * intensity]
      end
    end

    def / intensity
      if intensity.is_a? MTK::Intensity
        MTK::Intensity[to_f / intensity.value]
      else
        MTK::Intensity[to_f / intensity]
      end
    end

    def coerce(other)
      return MTK::Intensity[other], self
    end

  end

  # Construct a {Duration} from any supported type
  def Intensity(*anything)
    anything = anything.first if anything.length == 1
    case anything
      when Numeric then MTK::Intensity[anything]
      when String, Symbol then MTK::Intensity.from_s(anything)
      when Intensity then anything
      else raise "Intensity doesn't understand #{anything.class}"
    end
  end
  module_function :Intensity

end
