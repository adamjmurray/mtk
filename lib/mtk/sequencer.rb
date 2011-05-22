module MTK

  # An enumerator of {Note}s
  class Sequencer

    def initialize(pitches, intensities=nil, durations=nil)
      @pitches = pitches.clone
      @intensities = intensities ? intensities.clone : [Dynamics::mf]
      @durations = durations ? durations.clone : [1]
      reset
    end

    # reset the Sequence to the beginning
    def reset
      @p_idx = @i_idx = @d_idx = 0
    end

    # return next {Note} in sequence
    def next
      note = Note.new( @pitches[@p_idx], @intensities[@i_idx], @durations[@d_idx] )
      @p_idx = (@p_idx + 1) % @pitches.length
      @i_idx = (@i_idx + 1) % @intensities.length
      @d_idx = (@d_idx + 1) % @durations.length
      note
    end
  end
end
