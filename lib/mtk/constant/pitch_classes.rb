module MTK
  module Constant

    # Defines a constant for each {PitchClass} in the Western chromatic scale.
    module PitchClasses

      # The values of all "psuedo constants" defined in this module
      PITCH_CLASSES = []

      # The names of all "psuedo constants" defined in this module
      PITCH_CLASS_NAMES = PitchClass::NAMES

      for name in PITCH_CLASS_NAMES
        pc = PitchClass[name]
        PITCH_CLASSES << pc
        const_set name, pc
      end

      PITCH_CLASSES.freeze

      # Lookup the value of an pitch class constant by name.
      # @example lookup value of 'C'
      #         MTK::PitchClasses['C']
      # @see PitchClass.[]
      def self.[](name)
        begin
          const_get name
        rescue
          nil
        end
      end

    end
  end
end
