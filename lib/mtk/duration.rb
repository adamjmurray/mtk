module MTK

  # A measure of time in musical beats.
  # May be negative to indicate a rest, which uses the absolute value for the effective duration.
  class Duration

    include Comparable

    # The names of the base durations. See {MTK::Lang::Durations} for more info.
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

    # The number of beats, typically represented as a Rational
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
    # You may use the prefix '-' to negate the duration (which turns it into a rest of the same length).
    # You may also prefix (after the '-' if present) the base duration name with an integer, float, or rational number
    # to multiply the base duration value. Rationals are in the form "#!{numerator_integer}/#!{denominator_integer}".
    # @example lookup value of 'q.', which is 1.5 times a quarter note (1.5 beats):
    #          MTK::Duration.from_s('q.')
    # @example lookup the value of 3/4w, which three-quarters of a whole note (3 beats):
    #          MTK::Duration.from_s('3/4w')
    def self.from_s(s)
      if s =~ /^(-)?(\d+([\.\/]\d+)?)?([whqisrx])((\.|t)*)$/i
        name = $4.downcase
        modifier = $5.downcase
        modifier << $1 if $1 # negation
        multiplier = $2
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

      if multiplier
        case multiplier
          when /\./
            value *= multiplier.to_f
          when /\//
            numerator, denominator = multiplier.split('/')
            value *= Rational(numerator.to_i, denominator.to_i)
          else
            value *= multiplier.to_i
        end
      end

      self[value]
    end

    class << self
      alias :from_name :from_s
    end

    # The magnitude (absolute value) of the duration.
    # This is the actual duration for rests.
    # @see #rest?
    def length
      @value < 0 ? -@value : @value
    end

    # Durations with negative values are rests.
    # @see #length
    # @see #-@
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
      value = @value.to_s
      value = sprintf '%.2f', @value if value.length > 6 # threshold is 6 for no particular reason...
      "#{value} #{@value.abs > 1 || @value==0 ? 'beats' : 'beat'}"
    end

    def inspect
      "#<#{self.class}:#{object_id} @value=#{@value}>"
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

    # Add this duration to another.
    # @return a new Duration that has a value of the sum of the arguments.
    def + duration
      if duration.is_a? MTK::Duration
        MTK::Duration[@value + duration.value]
      else
        MTK::Duration[@value + duration]
      end
    end

    # Subtract another duration from this one.
    # @return a new Duration that has a value of the difference of the arguments.
    def - duration
      if duration.is_a? MTK::Duration
        MTK::Duration[@value - duration.value]
      else
        MTK::Duration[@value - duration]
      end
    end

    # Multiply this duration with another.
    # @return a new Duration that has a value of the product of the arguments.
    def * duration
      if duration.is_a? MTK::Duration
        MTK::Duration[@value * duration.value]
      else
        MTK::Duration[@value * duration]
      end
    end

    # Divide this duration with another.
    # @return a new Duration that has a value of the division of the arguments.
    def / duration
      if duration.is_a? MTK::Duration
        MTK::Duration[to_f / duration.value]
      else
        MTK::Duration[to_f / duration]
      end
    end

    # Negate the duration value.
    # Turns normal durations into rests and vice versa.
    # @return a new Duration that has a negated value.
    # @see #rest?
    def -@
      MTK::Duration[@value * -1]
    end

    # Allow basic math operations with Numeric objects.
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
