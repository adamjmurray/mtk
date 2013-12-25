module MTK
  module Core

    # A measure of intensity, using an underlying value in the range 0.0-1.0
    #
    # @see Lang::Intensities
    class Intensity

      include Comparable

      # The names of the base intensities. See {MTK::Lang::Intensities} for more info.
      NAMES = %w[ppp pp p mp mf f ff fff].freeze

      VALUES_BY_NAME = {
        'ppp' => 0.125,
        'pp' => 0.25,
        'p' => 0.375,
        'mp' => 0.5,
        'mf' => 0.625,
        'f' => 0.75,
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
        @flyweight[value] ||= new(value)
      end

      class << self
        alias :from_f :[]
        alias :from_i :[]
      end

      # Lookup an intensity by name.
      # This method supports appending '-' or '+' for more fine-grained values.
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

      def to_percent
        (@value * 100).round
      end

      def to_s
        "#{to_percent}% intensity"
      end

      def inspect
        "#<Intensity: @value=#{@value}>"
      end

      def ==( other )
        other.is_a? MTK::Core::Intensity and other.value == @value
      end

      def <=> other
        if other.respond_to? :value
          @value <=> other.value
        else
          @value <=> other
        end

      end

      def + intensity
        if intensity.is_a? MTK::Core::Intensity
          MTK::Core::Intensity[@value + intensity.value]
        else
          MTK::Core::Intensity[@value + intensity]
        end
      end

      def -intensity
        if intensity.is_a? MTK::Core::Intensity
          MTK::Core::Intensity[@value - intensity.value]
        else
          MTK::Core::Intensity[@value - intensity]
        end
      end

      def * intensity
        if intensity.is_a? MTK::Core::Intensity
          MTK::Core::Intensity[@value * intensity.value]
        else
          MTK::Core::Intensity[@value * intensity]
        end
      end

      def / intensity
        if intensity.is_a? MTK::Core::Intensity
          MTK::Core::Intensity[to_f / intensity.value]
        else
          MTK::Core::Intensity[to_f / intensity]
        end
      end

      def coerce(other)
        return MTK::Core::Intensity[other], self
      end

    end
  end

  # Construct a {Duration} from any supported type
  def Intensity(*anything)
    anything = anything.first if anything.length == 1
    case anything
      when Numeric then MTK::Core::Intensity[anything]
      when String, Symbol then MTK::Core::Intensity.from_s(anything)
      when Intensity then anything
      else raise "Intensity doesn't understand #{anything.class}"
    end
  end
  module_function :Intensity

end
