module Kreet
  
  # The velocity of a note.
  # Represented as a floating point value but easily converted to
  # and from an int value compatible with MIDI.
  
  class Velocity
    
    def initialize(value)
      @value = value
    end
    
    def name
      :velocity
    end

    attr_reader :value
    
  end
  
end