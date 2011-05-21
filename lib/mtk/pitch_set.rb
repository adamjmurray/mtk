module MTK

  # A set of {Pitch}es
  #
  class PitchSet

    attr_reader :pitches

    def initialize(pitches)
      @pitches = pitches.uniq.sort.freeze
    end

    def to_a
      Array.new(@pitches)
    end

    def to_pitch_class_set
      PitchClassSet.new @pitches.map{|p| p.pitch_class }
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

    def invert(center_pitch=@pitches.first)
      each_pitch_apply :invert, center_pitch
    end

    def inversion(number)
      number = number.to_i
      pitch_set = Array.new(@pitches)
      if number > 0
        number.times do |count|
          index = count % pitch_set.length
          pitch_set[index] += 12
        end
      else
        number.abs.times do |count|
          index = -(count + 1) % pitch_set.length # count from -1 downward to go backwards through the list starting at the end
          pitch_set[index] -= 12
        end
      end
      self.class.new pitch_set
    end

    def include? pitch
      @pitches.include? pitch
    end

    # @param other [#pitches, #to_a, Array]
    def == other
      if other.respond_to? :pitches
        @pitches == other.pitches
      elsif other.respond_to? :to_a
        @pitches == other.to_a
      else
        @pitches == other
      end
    end

    def to_s
      @pitches.inspect
    end

    #######################################
    protected

    def each_pitch_apply(method_name, *args, &block)
      self.class.new @pitches.map{|pitch| pitch.send(method_name, *args, &block) }
    end

  end
end
