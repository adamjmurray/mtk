module MTK
  module Constants

    # Defines a constant for each {PitchClass} in the Western chromatic scale.
    module PitchClasses

      # The values of all "psuedo constants" defined in this module
      PITCH_CLASSES = MTK::PitchClass::PITCH_CLASSES

      # The names of all "psuedo constants" defined in this module
      PITCH_CLASS_NAMES = MTK::PitchClass::NAMES

      PITCH_CLASSES.each { |pc| const_set pc.name, pc }

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
