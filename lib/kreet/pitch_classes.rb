module Kreet

  # Constants for the pitch classes in 'western' twelve-tone octaves.
  
  module PitchClasses

    PITCH_CLASSES = []

    PitchClass::Names.each_with_index do |name,value|
      pc = PitchClass.from_value( value )
      PITCH_CLASSES << pc
      const_set name, pc
    end

  end

end