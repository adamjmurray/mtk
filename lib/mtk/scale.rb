module MTK

  # A musical scale, which is a collection of Pitches
  class Scale
    attr_reader :pitches
    
    def initialize(pitches)
      @pitches = pitches.clone.freeze
    end
    
    def pitch_classes
      @pitches.map{|pitch| pitch.pitch_class }
    end
    
  end
  
end
