module Kreet

  # Constants for the pitch classes in the Western chromatic scale
  
  module PitchClasses

    PITCH_CLASSES = []

    PitchClass::NAMES.each_with_index do |name,value|
      pc = PitchClass.from_i( value )
      PITCH_CLASSES << pc
      const_set name, pc
    end

  end

end