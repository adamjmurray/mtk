module MTK

  # A measure of time in musical beats.
  # May be negative to indicate a rest, which uses the absolute value for the effective duration.
  class Duration

    include Comparable

    # The names of the base durations. See {MTK::Constants::Durations} for more info.
    NAMES = %w[w h q i s r x].freeze

    VALUES_BY_NAME = {
      'w' => 4,
      'h' => 2,
      'q' => 1,
      'i' => Rational(1,2),
      's' => Rational(1,4),
      'r' => Rational(1,8),
      'x' => Rational(1,16)
    }

    @flyweight = {}

    # The number of beats, typically representation as a Rational
    attr_reader :value

    def initialize( length_in_beats )
      @value = length_in_beats
    end

    # Return a duration, only constructing a new instance when not already in the flyweight cache
    def self.[](length_in_beats)
      if length_in_beats.is_a? Fixnum
        value = length_in_beats
      else
        value = Rational(length_in_beats)
      end
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
      if s =~ /^(-)?([whqisrx])((\.|t)*)$/i
        name = $2.downcase
        modifier = $3.downcase
        modifier << $1 if $1
      else
        raise ArgumentError.new("Invalid Duration string '#{s}'")
      end

      value = VALUES_BY_NAME[name]
      modifier.each_char do |mod|
        case mod
          when '-' then value *= -1
          when '.' then value *= Rational(3,2)
          when 't' then value *= Rational(2,3)
        end
      end
      self[value]
    end

    class << self
      alias :from_name :from_s
    end

    # The magnitude (absolute value) of the duration.
    # Indicate the "real" duration for rests.
    # @see rest?
    def length
      @value < 0 ? -@value : @value
    end

    # By convention, any negative durations are a rests
    # @see length
    def rest?
      @value < 0
    end

    # The number of beats as a floating point number
    def to_f
      @value.to_f
    end

    # The numerical value for the nearest whole number of beats
    def to_i
      @value.round
    end

    def to_s
      @value.to_s
    end

    def inspect
      "#{self.class}<#{to_s} #{@value > 1 ? 'beats' : 'beat'}>"
    end

    def ==( other )
      if other.is_a? MTK::Duration
        other.value == @value
      else
        other == @value
      end
    end

    def <=> other
      if other.respond_to? :value
        @value <=> other.value
      else
        @value <=> other
      end
    end

    def + duration
      if duration.is_a? MTK::Duration
        MTK::Duration[@value + duration.value]
      else
        MTK::Duration[@value + duration]
      end
    end

    def - duration
      if duration.is_a? MTK::Duration
        MTK::Duration[@value - duration.value]
      else
        MTK::Duration[@value - duration]
      end
    end

    def * duration
      if duration.is_a? MTK::Duration
        MTK::Duration[@value * duration.value]
      else
        MTK::Duration[@value * duration]
      end
    end

    def / duration
      if duration.is_a? MTK::Duration
        MTK::Duration[to_f / duration.value]
      else
        MTK::Duration[to_f / duration]
      end
    end

    def -@
      MTK::Duration[@value * -1]
    end

    def coerce(other)
      return MTK::Duration[other], self
    end

  end

  # Construct a {Duration} from any supported type
  def Duration(*anything)
    anything = anything.first if anything.length == 1
    case anything
      when Numeric then MTK::Duration[anything]
      when String, Symbol then MTK::Duration.from_s(anything)
      when Duration then anything
      else raise "Duration doesn't understand #{anything.class}"
    end
  end
  module_function :Duration

end
