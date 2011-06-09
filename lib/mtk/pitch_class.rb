module MTK

  # A class of pitches under octave equivalence.
  #
  # A {Pitch} has the same PitchClass as the {Pitches} one or more octaves away.

  class PitchClass

    NAMES = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B'].freeze

    VALID_NAMES_BY_VALUE = [
        ['B#', 'C', 'Dbb'],
        ['B##', 'C#', 'Db'],
        ['C##', 'D', 'Ebb'],
        ['D#', 'Eb', 'Fbb'],
        ['D##', 'E', 'Fb'],
        ['E#', 'F', 'Gbb'],
        ['E##', 'F#', 'Gb'],
        ['F##', 'G', 'Abb'],
        ['G#', 'Ab'],
        ['G##', 'A', 'Bbb'],
        ['A#', 'Bb', 'Cbb'],
        ['A##', 'B', 'Cb']
    ].freeze

    VALID_NAMES = VALID_NAMES_BY_VALUE.flatten.freeze

    attr_reader :name

    def initialize(name, int_value)
      @name, @int_value = name, int_value
    end
    private_class_method :new

    @flyweight = {}

    # Return a new object, only constructing a new instance when not already in the flyweight cache
    def self.[](name, value)
      @flyweight[name] ||= new(name, value) if VALID_NAMES.include? name
    end
    private_class_method :[]

    def self.from_s(s)
      s = s.to_s
      s = s[0..0].upcase + s[1..-1].downcase # normalize the name      
      VALID_NAMES_BY_VALUE.each_with_index do |names, value|
        return self[s, value] if names.include? s
      end
      nil
    end

    class << self
      alias from_name from_s # alias self.from_name to self.from_s
    end

    def self.from_i(value)
      value = value.to_i % 12
      name = NAMES[value]
      self[name, value]
    end

    def == other
      other.is_a? PitchClass and other.to_i == @int_value
    end

    def <=> other
      @int_value <=> other.to_i
    end

    def to_s
      @name
    end

    def to_i
      @int_value
    end

    def + interval
      self.class.from_i(to_i + interval.to_i)
    end
    alias transpose +

    def - interval
      self.class.from_i(to_i - interval.to_i)
    end

    def invert(center_pitch_class)
      self + 2*(center_pitch_class.to_i - to_i)
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
