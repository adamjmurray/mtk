module MTK

  # A set of all pitches that are an integer number of octaves apart.
  # A {Pitch} has the same PitchClass as the pitches one or more octaves away.
  # @see https://en.wikipedia.org/wiki/Pitch_class
  #
  class PitchClass

    # The normalized names of the 12 pitch classes in the chromatic scale.
    # The index of each {#name} is the pitch class's numeric {#value}.
    NAMES = %w( C Db D Eb E F Gb G Ab A Bb B ).freeze

    # All enharmonic names of the 12 pitch classes, including sharps, flats, double-sharps, and double-flats,
    # organized such that each index contains the allowed names of the pitch class with a {#value} equal to that index.
    VALID_NAMES_BY_VALUE =
    [ # (valid names ), # value # normalized name
      %w( B#  C  Dbb ), #   0   #   C
      %w( B## C# Db  ), #   1   #   Db
      %w( C## D  Ebb ), #   2   #   D
      %w( D#  Eb Fbb ), #   3   #   Eb
      %w( D## E  Fb  ), #   4   #   E
      %w( E#  F  Gbb ), #   5   #   F
      %w( E## F# Gb  ), #   6   #   Gb
      %w( F## G  Abb ), #   7   #   G
      %w( G#     Ab  ), #   8   #   Ab
      %w( G## A  Bbb ), #   9   #   A
      %w( A#  Bb Cbb ), #  10   #   Bb
      %w( A## B  Cb  )  #  11   #   B
    ].freeze

    # All valid enharmonic pitch class names in a flat list.
    VALID_NAMES = VALID_NAMES_BY_VALUE.flatten.freeze

    # The name of this pitch class.
    # One of the {NAMES} defined by this class.
    attr_reader :name

    # The value of this pitch class.
    # An integer from 0..11 that indexes this pitch class in {PITCH_CLASSES} and the {#name} in {NAMES}.
    attr_reader :value

    def initialize(name, value)
      @name, @value = name, value
    end
    private_class_method :new

    @flyweight = {}

    # Lookup a PitchClass by name.
    # @param name [String, #to_s] one of the values in {VALID_NAMES}
    def self.[](name)
      pitch_class = @flyweight[name]
      return pitch_class if pitch_class

      # normalize the name:
      normalized_name = name.to_s
      normalized_name = normalized_name[0..0].upcase + normalized_name[1..-1].downcase
      pitch_class = @flyweight[normalized_name]
      return pitch_class if pitch_class

      VALID_NAMES_BY_VALUE.each_with_index do |names,value|
        if names.include? normalized_name
          return ( @flyweight[name] ||= new(normalized_name,value) )
        end
      end
      nil
    end

    class << self
      alias :from_s :[]
      alias :from_name :[]
    end

    # All 12 pitch classes in the chromatic scale.
    # The index of each pitch class is the pitch class's numeric {#value}.
    PITCH_CLASSES = NAMES.map{|name| from_name name }.freeze

    # return the pitch class with the given integer value mod 12
    def self.from_i(value)
      PITCH_CLASSES[value.to_i % 12]
    end

    class << self
      alias :from_value :from_i
    end

    # return the pitch class with the given float rounded to the nearest integer, mod 12
    def self.from_f(value)
      from_i value.to_f.round
    end

    def == other
      other.is_a? PitchClass and other.value == @value
    end

    def <=> other
      @value <=> other.to_i
    end

    # This pitch class's normalized {#name}.
    # @see NAMES
    def to_s
      @name.to_s
    end

    # This pitch class's integer {#value}
    def to_i
      @value.to_i
    end

    # This pitch class's {#value} as a floating point number
    def to_f
      @value.to_f
    end

    # Transpose this pitch class by adding it's value to the value given (mod 12)
    def + interval
      value = (to_i + interval.to_f).round
      self.class.from_value value
    end
    alias transpose +

    # Transpose this pitch class by subtracing the given value from this value (mod 12)
    def - interval
      value = (to_i - interval.to_f).round
      self.class.from_value value
    end

    def invert(center_pitch_class)
      delta = (2*(center_pitch_class.to_f - to_i)).round
      self + delta
    end

    # the smallest interval in semitones that needs to be added to this PitchClass to reach the given PitchClass
    def distance_to(pitch_class)
      delta = (pitch_class.to_i - to_i) % 12
      if delta > 6
        delta -= 12
      elsif delta == 6 and to_i >= 6
        # this is a special edge case to prevent endlessly ascending pitch sequences when alternating between two pitch classes a tritone apart
        delta = -6
      end
      delta
    end

  end

  # Construct a {PitchClass} from any supported type
  def PitchClass(anything)
    case anything
      when Numeric then PitchClass.from_i(anything)
      when String, Symbol then PitchClass.from_s(anything)
      when PitchClass then anything
      else raise "PitchClass doesn't understand #{anything.class}"
    end
  end
  module_function :PitchClass

end
