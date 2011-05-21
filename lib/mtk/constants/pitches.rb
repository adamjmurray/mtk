module MTK

  # Defines a constants for each {Pitch} in the standard MIDI range using scientific pitch notation.
  #
  # See http://en.wikipedia.org/wiki/Scientific_pitch_notation
  #
  # Note that because the character '#' cannot be used in the name of a constant,
  # The "black key" pitches are all named as flats with 'b' (for example, Gb3 or Cb4)

  module Pitches

    # An array of all the pitch constants defined in this module
    PITCHES = []

    128.times do |note_number|
      pitch = Pitch.from_i( note_number )
      PITCHES << pitch
      octave_str = pitch.octave.to_s.sub(/-/,'_') # '_1' for -1
      const_set "#{pitch.pitch_class}#{octave_str}", pitch
    end

  end

end
