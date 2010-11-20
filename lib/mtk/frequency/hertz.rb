module MTK::Frequency

  # A frequency expressed in hertz (Hz)

  class Hertz < MTK::Scalar

    def to_hz
      self
    end

    def to_khz
      Kilohertz.new( @value / 1000.0 )
    end

    def to_semitones
      Semitones.new( value_in_semitones )
    end

    def to_cents
      Cents.new( value_in_semitones * 100 )
    end    

    def value_in_hertz
      @value
    end

    def value_in_semitones
      69 + 12 * Math.log(value_in_hertz/440.0, 2)
    end
    
    def to_s
      @value.to_s + ' Hz'
    end

    ###########################################
    private
    
    def value_of_compatible_type( something )      
      something.to_hz.value if something.respond_to? :to_hz
    end

  end
end