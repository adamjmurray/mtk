module MTK

  # A multi-pitch, note-like {Event} defined by a {PitchSet}, intensity, and duration
  class Chord < Event

    # the {PitchSet} of the chord
    attr_reader :pitch_set

    def initialize(pitches, intensity, duration)
      @pitch_set = if pitches.is_a? PitchSet
        pitches
      else
        PitchSet.new(pitches)
      end
      super(intensity, duration)
    end

    def self.from_hash(hash)
      new hash[:pitch_set], hash[:intensity], hash[:duration]
    end

    def to_hash
      super.merge({ :pitch_set => @pitch_set })
    end

    def pitches
      @pitch_set.pitches
    end

    def transpose(interval)
      self.class.new( @pitch_set.transpose(interval), @intensity, @duration )
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
