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

  end
end