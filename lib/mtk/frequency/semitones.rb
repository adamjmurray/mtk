module MTK::Frequency

  # A frequency in the logarithmic scale, expressed in semitones

  class Semitones < MTK::Scalar

    def to_hz
      Hertz.new( value_in_hertz )
    end
    alias to_hertz to_hz

    def to_khz
      Kilohertz.new( value_in_hertz / 1000.0 )
    end
    alias to_kilohertz to_khz

    def to_semitones
      self
    end

    def to_cents
      Cents.new( @value * 100 )
    end    

    def value_in_hertz
      2**((value_in_semitones.to_f-69)/12) * 440
    end

    def value_in_semitones
      @value
    end

  end
end