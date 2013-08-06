module MTK
  module Groups

    # A {PitchClassGroup} that represents a musical scale.
    # Although scales are typically ascending and don't contain duplicates, no such constraints are imposed in this class.
    # It is assumed all {PitchClass}es in the Scale occur within one octave, and that the {#tonic} is the first pitch class.
    #
    # @see https://en.wikipedia.org/wiki/Musical_scale
    # @see https://en.wikipedia.org/wiki/List_of_musical_scales_and_modes
    #
    class Scale < PitchClassGroup

      alias steps elements

      # The root (first) note of the scale
      alias tonic first

      # Lookup a scale step by step number (starts at 1), wrapping around the end of the scale as needed.
      #
      # This counts from 1 for intuitiveness, so that step 2 is a second above the tonic (for a typical diatonic scale),
      # step 3 is a third, step 8 is the octave, etc.
      #
      # @return [PitchClass] the pitch class at the given step number
      # @return nil if the Scale is empty or if the step number <= 0
      # @see #pitch_for_step
      #
      def step(step_number)
        length = @elements.length
        if length == 0 or step_number <= 0
          nil
        else
          @elements[(step_number-1) % length]
        end
      end

      # Lookup a scale step by step number (starts at 1), wrapping around the end of the scale as needed.
      #
      # This counts from 1 for intuitiveness, so that step 2 is a second above the tonic (for a typical diatonic scale),
      # step 3 is a third, step 8 is the octave, etc.
      #
      # @return [Pitch] the pitch with the pitch class at the given step number that's closest to nearest_pitch
      # @return nil if the Scale is empty or if the step number <= 0
      # @see #step
      #
      def pitch_for_step(step_number, nearest_pitch=MTK::Lang::Pitches::C4)
        step_number = step_number.to_i
        pitch_class = step(step_number)
        if pitch_class.nil?
          nil
        else
          octave_offset = (step_number-1)/length * 12
          nearest_pitch.nearest(pitch_class) + octave_offset
        end
      end
    end

  end


  # Construct a {MTK::Groups::Scale} from any supported type
  # @see #MTK::Groups::Scale
  def Scale(*anything)
    MTK::Groups::Scale.new(MTK::Groups.to_pitch_classes *anything)
  end
  module_function :Scale

end


