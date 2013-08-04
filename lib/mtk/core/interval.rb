module MTK
  module Core

    # A measure of intensity, using an underlying value in the range 0.0-1.0
    #
    # @see Lang::Intervals
    class Interval

      include Comparable

      # The preferred names of all pre-defined intervals
      # @see ALL_NAMES
      NAMES = %w[P1 m2 M2 m3 M3 P4 TT P5 m6 M6 m7 M7 P8].freeze

      # All valid names of pre-defined intervals, indexed by their value.
      # @see ALL_NAMES
      # @see NAMES
      # @see http://en.wikipedia.org/wiki/Interval_(music)#Main_intervals
      NAMES_BY_VALUE =
        [ #   names      # value # description     # enharmonic equivalents
          %w( P1 d2 ),   #   0   #  unison         #  diminished second
          %w( m2 a1 ),   #   1   #  minor second   #  augmented unison
          %w( M2 d3 ),   #   2   #  major second   #  diminished third
          %w( m3 a2 ),   #   3   #  minor third    #  augmented second
          %w( M3 d4 ),   #   4   #  major third    #  diminished fourth
          %w( P4 a3 ),   #   5   #  perfect fourth #  augmented third
          %w( TT a4 d5 ),#   6   #  tritone        #  augmented fourth, diminished fifth
          %w( P5 d6 ),   #   7   #  perfect fifth  #  diminished sixth
          %w( m6 a5 ),   #   8   #  minor sixth    #  augmented fifth
          %w( M6 d7 ),   #   9   #  major sixth    #  diminished seventh
          %w( m7 a6 ),   #  10   #  minor seventh  #  augmented sixth
          %w( M7 d8 ),   #  11   #  major seventh  #  diminished octave
          %w( P8 a7 )    #  12   #  octave         #  augmented seventh
        ].freeze

      # A mapping from intervals names to their value
      VALUES_BY_NAME = Hash[ # a map from a list of name,value pairs
          NAMES_BY_VALUE.map.with_index do |names,value|
            names.map{|name| [name,value] }
          end.flatten(1)
      ].freeze

      # All valid interval names
      # @see NAMES_BY_VALUE
      ALL_NAMES = NAMES_BY_VALUE.flatten.freeze


      @flyweight = {}

      # The number of semitones represented by this interval
      attr_reader :value

      def initialize(value)
        @value = value
      end

      # Return an {Interval}, only constructing a new instance when not already in the flyweight cache
      def self.[](value)
        value = value.to_f unless value.is_a? Fixnum
        @flyweight[value] ||= new(value)
      end

      class << self
        alias :from_f :[]
        alias :from_i :[]
      end

      # Lookup an interval duration by name.
      def self.from_s(s)
        value = VALUES_BY_NAME[s.to_s]
        raise ArgumentError.new("Invalid Interval string '#{s}'") unless value
        self[value]
      end

      class << self
        alias :from_name :from_s
      end

      # The number of semitones as a floating point number
      def to_f
        @value.to_f
      end

      # The numerical value for the nearest whole number of semitones in this interval
      def to_i
        @value.round
      end

      def to_s
        @value.to_s
      end

      def inspect
        "#{self.class}<#{to_s} semitones>"
      end

      def ==( other )
        other.is_a? MTK::Core::Interval and other.value == @value
      end

      def <=> other
        if other.respond_to? :value
          @value <=> other.value
        else
          @value <=> other
        end
      end

      def + interval
        if interval.is_a? MTK::Core::Interval
          MTK::Core::Interval[@value + interval.value]
        else
          MTK::Core::Interval[@value + interval]
        end
      end

      def -interval
        if interval.is_a? MTK::Core::Interval
          MTK::Core::Interval[@value - interval.value]
        else
          MTK::Core::Interval[@value - interval]
        end
      end

      def * interval
        if interval.is_a? MTK::Core::Interval
          MTK::Core::Interval[@value * interval.value]
        else
          MTK::Core::Interval[@value * interval]
        end
      end

      def / interval
        if interval.is_a? MTK::Core::Interval
          MTK::Core::Interval[to_f / interval.value]
        else
          MTK::Core::Interval[to_f / interval]
        end
      end

      def -@
        MTK::Core::Interval[@value * -1]
      end

      def coerce(other)
        return MTK::Core::Interval[other], self
      end

    end
  end

  # Construct a {Duration} from any supported type
  def Interval(*anything)
    anything = anything.first if anything.length == 1
    case anything
      when Numeric then MTK::Core::Interval[anything]
      when String, Symbol then MTK::Core::Interval.from_s(anything)
      when Interval then anything
      else raise "Interval doesn't understand #{anything.class}"
    end
  end
  module_function :Interval

end
