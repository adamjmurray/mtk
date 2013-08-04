module MTK
  module Lang

    # Defines a constants for each {Core::Pitch} in the standard MIDI range using scientific pitch notation.
    #
    # See http://en.wikipedia.org/wiki/Scientific_pitch_notation
    #
    # @note Because the character '#' cannot be used in the name of a constant,
    #     the "black key" pitches are all named as flats with 'b' (for example, Gb3 or Db4)
    # @note Because the character '-' (minus) cannot be used in the name of a constant,
    #     the low pitches use '_' (underscore) in place of '-' (minus) (for example C_1).
    #
    # @see Core::Pitch
    # @see Events::Note
    module Pitches

      # The values of all constants defined in this module
      PITCHES = []

      # The names of all constants defined in this module
      PITCH_NAMES = []

      128.times do |note_number|
        pitch = MTK::Core::Pitch.from_i( note_number )
        PITCHES << pitch

        octave_str = pitch.octave.to_s.sub(/-/,'_') # '_1' for -1
        name = "#{pitch.pitch_class}#{octave_str}"
        PITCH_NAMES << name

        # TODO? also define lower case pseudo constants for consistency with the grammar?

        const_set name, pitch
      end

      PITCHES.freeze
      PITCH_NAMES.freeze

      # Lookup the value of an pitch constant by name.
      # @example lookup value of 'C3'
      #         MTK::Core::Pitches['C3']
      # @see Core::Pitch.from_s
      # @note Unlike {Core::Pitch.from_s} this method will accept either '_' (underscore) or '-' (minus) and treat it like '-' (minus)
      # @note Unlike {Core::Pitch.from_s} this method only accepts the accidental 'b'
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
