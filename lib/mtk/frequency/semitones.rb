module MTK::Frequency

  # A frequency in the logarithmic scale, expressed in semitones

  class Semitones < MTK::Scalar

    def to_hz
      Hertz.new( value_in_hertz )
    end

    def to_khz
      Kilohertz.new( value_in_hertz / 1000.0 )
    end

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
    
    ###########################################
    private
    
    def value_of_compatible_type( something )      
      something.to_semitones.value if something.respond_to? :to_semitones
    end

  end
end