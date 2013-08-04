module MTK
  module Lang

    # Defines a constant for each {Core::PitchClass} in the Western chromatic scale.
    #
    # Because '#' is not a valid identifier character in Ruby. All chromatic pitch classes are defined as
    # the flat of a diatonic pitch class, for example Eb is a constant because D# is not a valid Ruby constant name.
    #
    # To help automate the documentation, the constants are listed under "Instance Attribute Summary" on this page.
    #
    # @see Core::PitchClass
    #
    module PitchClasses

      # @private
      # @!macro [attach] define_pitch_class
      #   PitchClass $1 $3
      #   @!attribute [r]
      #   @return [MTK::Core::PitchClass] PitchClass $1 (value $2)
      def self.define_pitch_class name, value, more_info=nil
        const_set name, MTK::Core::PitchClass.from_name(name)
      end

      define_pitch_class 'C', 0

      define_pitch_class 'Db', 1, '(also known as C#)'

      define_pitch_class 'D', 2

      define_pitch_class 'Eb', 3, '(also known as D#)'

      define_pitch_class 'E', 4

      define_pitch_class 'F', 5

      define_pitch_class 'Gb', 6, '(also known as F#)'

      define_pitch_class 'G', 7

      define_pitch_class 'Ab', 8, '(also known as G#)'

      define_pitch_class 'A', 9

      define_pitch_class 'Bb', 10, '(also known as A#)'

      define_pitch_class 'B', 11

      # All constants defined in this module
      PITCH_CLASSES = [C, Db, D, Eb, E, F, Gb, G, Ab, A, Bb, B].freeze

      # The names of all constants defined in this module
      # @see MTK::Core::PitchClass::NAMES
      PITCH_CLASS_NAMES = MTK::Core::PitchClass::NAMES

    end
  end
end
