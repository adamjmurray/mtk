module MTK::Frequency

  # A frequency in the logarithmic scale, expressed in cents
  
  class Cents < Semitones

    def to_semitones
      Semitones.new( @value * 100 )
    end

    def to_cents
      self
    end    

    def value_in_semitones
      @value / 100.0
    end
    
    ###########################################
    private
    
    def value_of_compatible_type( something )      
      something.to_semitones.value if something.respond_to? :to_semitones
    end

  end
end