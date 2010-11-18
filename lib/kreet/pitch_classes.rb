module Kreet

  # Defines a constant for each {PitchClass}in the Western chromatic scale.
  
  module PitchClasses

    # An array of all pitch class constants defined in this module
    PITCH_CLASSES = []

    PitchClass::NAMES.each_with_index do |name,value|
      pc = PitchClass.from_i( value )
      PITCH_CLASSES << pc
      const_set name, pc
    end

  end

end