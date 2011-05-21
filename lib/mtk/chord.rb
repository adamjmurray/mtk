module MTK

  # A multi-pitch, note-like {Event} defined by a {PitchSet}, intensity, and duration
  class Chord < Event

    # the {PitchSet} of the chord
    attr_reader :pitch_set

    def initialize(pitch_set, intensity, duration)
      @pitch_set = pitch_set
      super(intensity, duration)
    end

    def self.from_hash(hash)
      new hash[:pitch_set], hash[:intensity], hash[:duration]
    end

    def to_hash
      super.merge({ :pitch_set => @pitch_set })
    end

    def transpose(interval)
      self.class.new(@pitch_set + interval, @intensity, @duration)
    end

    def == other
      super and other.respond_to? :pitch_set and @pitch_set == other.pitch_set
    end

    def to_s
      "Chord(#{pitch_set}, #{super})"
    end

    def inspect
      "Chord(#{pitch_set}, #{super})"
    end
  end

end
