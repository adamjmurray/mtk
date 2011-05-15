module MTK

  # A musical event defined in terms of pitch, intensity, and duration

  class Note

    # frequency of the note as a Pitch
    attr_reader :pitch

    # intensity of the note as a value in the range 0.0 - 1.0
    attr_reader :intensity

    # duration of the note in beats (e.g. 1.0 is a quarter note in 4/4 time signatures)
    attr_reader :duration
    
    def initialize(pitch, intensity, duration)
      @pitch, @intensity, @duration = pitch, intensity, duration
    end

    def transpose(interval)
      self.class.new(@pitch+interval, @intensity, @duration)
    end

    def scale_intensity(scaling_factor)
      self.class.new(@pitch, @intensity*scaling_factor.to_f, @duration)
    end

    def scale_duration(scaling_factor)
      self.class.new(@pitch, @intensity, @duration*scaling_factor.to_f)
    end

    def == other
      other.respond_to? :pitch and @pitch == other.pitch and
      other.respond_to? :intensity and @intensity == other.intensity and
      other.respond_to? :duration and @duration == other.duration
    end

  end

end
