module MTK::Frequency
  
  # A frequency expressed in Kilohertz (kHz)
  
  class Kilohertz < Hertz
        
    def to_hz
      Hertz.new( value_in_hertz )
    end
    
    def to_khz
      self
    end
    
    def value_in_hertz
      @value * 1000
    end
    
    ###########################################
    private
    
    def value_of_compatible_type( something )      
      something.to_khz.value if something.respond_to? :to_khz
    end

  end
  
end