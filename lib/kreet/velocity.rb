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
        
    # Return the integer value for this object
    def to_i
      @value.round
    end  
    
    def to_f
      @value.to_f
    end  

    def == other
      value == value_of( other )
    end
    
    def <=> other
      value <=> value_of( other )
    end
    
    def + param
      Velocity.new( value + value_of( param ))
    end

    def - param
      Velocity.new( value - value_of( param ))    
    end

    def * param
      Velocity.new( value * value_of( param ))
    end

    def / param
      Velocity.new( value / value_of( param ))
    end

    def % param
      Velocity.new( value % value_of( param ))
    end
       
    private
    def value_of something
      if something.is_a? Numeric
        something
      else
        something.value
      end
    end
    
  end
  
end