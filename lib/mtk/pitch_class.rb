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
    # @see VALID_NAMES_BY_VALUE
    VALID_NAMES = VALID_NAMES_BY_VALUE.flatten.freeze

    # A mapping from valid names to the value of the pitch class with that name
    VALUES_BY_NAME = Hash[ # a map from a list of name,value pairs
      VALID_NAMES_BY_VALUE.map.with_index do |valid_names,value|
        valid_names.map{|name| [name,value] }
      end.flatten(1)
    ].freeze


    # The name of this pitch class.
    # One of the {NAMES} defined by this class.
    attr_reader :name

    # The value of this pitch class.
    # An integer from 0..11 that indexes this pitch class in {PITCH_CLASSES} and the {#name} in {NAMES}.
    attr_reader :value


    private  ######
    # Even though new is a private_class_method, YARD gets confused so we temporarily go private

    def initialize(name, value)
      @name, @value = name, value
    end
    private_class_method :new

    @flyweight = {}

    public   ######


    # Lookup a PitchClass by name or value.
    # @param name_or_value [String,Symbol,Numeric] one of {VALID_NAMES} or 0..12
    # @return the PitchClass representing the argument
    # @raise ArgumentError for arguments that cannot be converted to a PitchClass
    def self.[] name_or_value
      @flyweight[name_or_value] ||= case name_or_value
        when String,Symbol then from_name(name_or_value)
        when Numeric       then from_value(name_or_value.round)
        else raise ArgumentError.new("PitchClass.[] doesn't understand #{name_or_value.class}")
      end
    end

    # Lookup a PitchClass by name.
    # @param name [String,#to_s] one of {VALID_NAMES} (case-insensitive)
    def self.from_name(name)
      @flyweight[name] ||= (
        valid_name = name.to_s.capitalize
        value = VALUES_BY_NAME[valid_name] or raise NameError.new("Invalid PitchClass name: #{name}")
        new(valid_name,value)
      )
    end

    class << self
      alias from_s from_name
    end

    # All 12 pitch classes in the chromatic scale.
    # The index of each pitch class is the pitch class's numeric {#value}.
    PITCH_CLASSES = NAMES.map{|name| from_name name }.freeze

    # return the pitch class with the given integer value mod 12
    # @param value [Integer,#to_i]
    def self.from_value(value)
      PITCH_CLASSES[value.to_i % 12]
    end

    class << self
      alias from_i from_value
    end

    # return the pitch class with the given float rounded to the nearest integer, mod 12
    # @param value [Float,#to_f]
    def self.from_f(value)
      from_i value.to_f.round
    end

    # Compare 2 pitch classes for equal values.
    # @param other [PitchClass]
    # @return true if this pitch class's value is equal to the other pitch class's value
    def == other
      other.is_a? PitchClass and other.value == @value
    end

    # Compare a pitch class with another pitch class or integer value
    # @param other [PitchClass,#to_i]
    # @return -1, 0, or +1 depending on whether this pitch class's value is less than, equal to, or greater than the other object's integer value
    # @see http://ruby-doc.org/core-1.9.3/Comparable.html
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
    # @param interval [PitchClass,Float,#to_f]
    def + interval
      new_value = (value + interval.to_f).round
      self.class.from_value new_value
    end
    alias transpose +

    # Transpose this pitch class by subtracing the given value from this value (mod 12)
    # @param interval [PitchClass,Float,#to_f]
    def - interval
      new_value = (value - interval.to_f).round
      self.class.from_value new_value
    end

    # Inverts (mirrors) the pitch class around the given center
    # @param center_pitch_class [PitchClass,Pitch,Float,#to_f] the value to "mirror" this pitch class around
    def invert(center)
      delta = (2*(center.to_f - value)).round
      self + delta
    end

    # the smallest interval in semitones that needs to be added to this PitchClass to reach the given PitchClass
    # @param pitch_class [PitchClass,#value]
    def distance_to(pitch_class)
      delta = (pitch_class.value - value) % 12
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
  # @param anything [PitchClass,String,Symbol,Numeric,#to_f,#to_i,#to_s]
  def PitchClass(anything)
    return anything if anything.is_a? PitchClass
    begin
      PitchClass[anything]
    rescue ArgumentError
      if anything.respond_to? :to_f
        PitchClass.from_f anything.to_f
      elsif anything.respond_to? :to_i
          PitchClass.from_i anything.to_i
      elsif anything.respond_to? :to_s
        PitchClass.from_s anything.to_s
      else
        raise
      end
    end
  end
  module_function :PitchClass

end
