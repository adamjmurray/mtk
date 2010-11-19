module MTK::Frequency

  # A frequency expressed in hertz (Hz)

  class Hertz < MTK::Scalar

    def to_hz
      self
    end
    alias to_hertz to_hz

    def to_khz
      Kilohertz.new( @value / 1000.0 )
    end
    alias to_kilohertz to_khz

    def to_semitones
      # TODO: Semitones.new
      Scalar.new( value_in_semitones )
    end

    def to_cents
      # TODO: Cents.new
      Scalar.new( value_in_semitones * 100 )
    end    

    def value_in_hertz
      @value
    end

    def value_in_semitones
      69 + 12 * Math.log(value_in_hertz/440.0, 2)
    end

  end
end