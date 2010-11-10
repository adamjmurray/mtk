module Kreet

  # Constants for the pitch classes in 'western' twelve-tone octaves.
  
  module PitchClasses

    PITCH_CLASSES = []

    ['C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B'].each_with_index do |name,value|
      pc = PitchClass.new( name, value )
      PITCH_CLASSES << pc
      const_set name, pc
    end

  end

end