module MTK

  # An abstract musical event that has an intensity and a duration
  # @abstract
  class Event

    # intensity of the note as a value in the range 0.0 - 1.0
    attr_reader :intensity

    # duration of the note in beats (e.g. 1.0 is a quarter note in 4/4 time signatures)
    attr_reader :duration

    def initialize(intensity, duration)
      @intensity, @duration = intensity, duration
    end

    def self.from_hash(hash)
      new hash[:intensity], hash[:duration]
    end

    def to_hash
      { :intensity => @intensity, :duration => @duration }
    end

    def clone_with(hash)
      self.class.from_hash(to_hash.merge hash)
    end

    def scale_intensity(scaling_factor)
      clone_with :intensity => @intensity * scaling_factor.to_f
    end

    def scale_duration(scaling_factor)
      clone_with :duration => @duration * scaling_factor.to_f
    end

    # intensity scaled to the MIDI range 0-127
    def velocity
      (127 * @intensity).round
    end

    def duration_in_pulses(pulses_per_beat)
      (@duration * pulses_per_beat).round
    end

    def == other
      other.respond_to? :intensity and @intensity == other.intensity and
      other.respond_to? :duration and @duration == other.duration
    end

    def to_s
      "#{sprintf '%.2f',@intensity}, #{sprintf '%.2f',@duration}"
    end

    def inspect
      "#@intensity, #@duration"
    end

  end

end
