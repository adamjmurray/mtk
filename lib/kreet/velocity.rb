module Kreet
  
  # The velocity of a note.
  # Represented as a floating point value but easily converted to
  # and from an int value compatible with MIDI.
  
  class Velocity
    
    include Comparable    
    
    def initialize( value )
      @value = value
    end
    
    def name
      :velocity
    end

    attr_reader :value

    # Construct a new Velocity object given an integer value
    def self.from_i( int_value )
      new( int_value / 127.0 )
    end
    
    # Return the integer value for this object
    def to_i
      @int_value ||= (@value * 127).round
    end
    
    def ==(other)
      other.respond_to? :value and value == other.value
    end
    
    def <=>(other)
      value <=> other.value
    end
    
  end
  
end