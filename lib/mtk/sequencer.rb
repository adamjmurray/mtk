module MTK

  # An endless enumerator of {Note}s
  class Sequencer

    attr_reader :pitches, :intensities, :durations
    
    def initialize(pitches, intensities=nil, durations=nil)
      @pitches, @intensities, @durations = pitches, intensities, durations
      reset
    end

    # reset the Sequence to the beginning
    def reset
      @p_idx = @i_idx = @d_idx = -1
      @pitch = Pitches::C4
      @intensity = Dynamics::mf
      @duration = 1
    end

    # return next {Note} in sequence
    def next
      pitch,intensity,duration = next_pitch,next_intensity,next_duration
      case pitch
        when PitchSet then Chord.new(pitch, intensity, duration)
        else Note.new(pitch, intensity, duration)
      end
    end

    ##################################
    private

    def next_pitch
      if @pitches and not @pitches.empty?
        @p_idx = (@p_idx + 1) % @pitches.length
        value = @pitches[@p_idx]
        @pitch = case value
          when Pitch,PitchSet
            value
          when Numeric
            @pitch + value
          when PitchClass
            pitch = @pitch
            pitch = pitch.pitches.first if @pitch.is_a? PitchSet # calculate relative to lowest note of PitchSets
            @pitch + pitch.pitch_class.distance_to(value)
          else
            @pitch
        end
      end
      @pitch
    end

    def next_intensity
      if @intensities and not @intensities.empty?
        @i_idx = (@i_idx + 1) % @intensities.length
        @intensity = @intensities[@i_idx] || @intensity
      end
      @intensity
    end

    def next_duration
      if @durations and not @durations.empty?
        @d_idx = (@d_idx + 1) % @durations.length
        @duration = @durations[@d_idx] || @duration
      end
      @duration
    end

  end
end
