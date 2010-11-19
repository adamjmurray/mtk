module MTK::Frequency
  
  # A frequency expressed in Kilohertz (kHz)
  
  class Kilohertz < Hertz
        
    def to_hz
      Hertz.new( value_in_hertz )
    end
    
    def to_khz
      self
    end
    
    def to_semitones
      # TODO: Semitones.new
      Scalar.new( value_in_semitones )
    end
    
    def to_cents
      # TODO: Cents.new
      Scalar.new( value_in_semitones * 100 )
    end    
    
    def coerce(other)
      case other
      when Numeric
        return [ Hertz.new( other ), self ]
      end
    end
    
    def value_in_hertz
      @value * 1000
    end
    
    # def value_of( something )
    #   case something
    #   when Numeric
    #     
    #   when 
    #     
    #   end
    # end

  end
  
end