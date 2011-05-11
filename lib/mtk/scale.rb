module MTK

  # A musical scale, which is a collection of Pitches
  class Scale
    attr_reader :pitches
    
    def initialize(pitches)
      @pitches = pitches.clone.freeze
    end
    
    def pitch_classes
      @pitch_classes ||= @pitches.map{|p| p.pitch_class }.uniq
    end
    
  end
  
end
