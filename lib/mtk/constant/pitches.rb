module MTK
  module Constant

    # Defines a constants for each {Pitch} in the standard MIDI range using scientific pitch notation.
    #
    # See http://en.wikipedia.org/wiki/Scientific_pitch_notation
    #
    # @note Because the character '#' cannot be used in the name of a constant,
    #     the "black key" pitches are all named as flats with 'b' (for example, Gb3 or Cb4)
    # @note Because the character '-' (minus) cannot be used in the name of a constant,
    #     the low pitches use '_' (underscore) in place of '-' (minus) (for example C_1).
    module Pitches

      # The values of all "psuedo constants" defined in this module
      PITCHES = []

      # The names of all "psuedo constants" defined in this module
      PITCH_NAMES = []

      128.times do |note_number|
        pitch = Pitch.from_i( note_number )
        PITCHES << pitch

        octave_str = pitch.octave.to_s.sub(/-/,'_') # '_1' for -1
        name = "#{pitch.pitch_class}#{octave_str}"
        PITCH_NAMES << name

        const_set name, pitch
      end

      PITCHES.freeze
      PITCH_NAMES.freeze

      # Lookup the value of an pitch constant by name.
      # @example lookup value of 'C3'
      #         MTK::Pitches['C3']
      # @see Pitch.from_s
      # @note Unlike {Pitch.from_s} this method will accept either '_' (underscore) or '-' (minus) and treat it like '-' (minus)
      # @note Unlike {Pitch.from_s} this method only accepts the accidental 'b'
      def self.[](name)
        begin
          const_get name.sub('-','_')
        rescue
          nil
        end
      end

    end
  end
end
