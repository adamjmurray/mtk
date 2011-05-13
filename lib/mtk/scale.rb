module MTK

  # A musical scale, which is a collection of Pitches
  class Scale

    attr_reader :pitches
    alias to_a pitches

    def initialize(pitches)
      @pitches = pitches.clone.freeze
    end
    
    def pitch_classes
      @pitch_classes ||= @pitches.map{|p| p.pitch_class }.uniq
    end

    def + semitones
      each_pitch_apply :+, semitones
    end

    def - semitones
      each_pitch_apply :-, semitones
    end

    def invert(center_pitch)
      each_pitch_apply :invert, center_pitch
    end

    def include? pitch
      @pitches.include? pitch
    end

    def == other
      to_a == other.to_a
    end

    #######################################
    private

    def each_pitch_apply(method_name, *args, &block)
      self.class.new @pitches.map{|pitch| pitch.send(method_name, *args, &block) }
    end

  end
end
