module MTK

  # Defines a constant for each {PitchClass}in the Western chromatic scale.

  module PitchClasses

    # An array of all pitch class constants defined in this module
    PITCH_CLASSES = []

    for name in PitchClass::NAMES
      pc = PitchClass.from_name name
      PITCH_CLASSES << pc
      const_set name, pc
    end

  end

end
