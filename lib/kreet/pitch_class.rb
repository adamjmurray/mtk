module Kreet
  
  # A class of pitches under octave equivalence.
  # Pitches one or more octaves away from each other have the same pitch class.
  
  class PitchClass
    
    attr_reader :name, :value
    
    def initialize( name, value )
      @name, @value = name, value
    end
    
    def ==( other )
      other.respond_to? :name and
       other.respond_to? :value and
        other.name == name and other.value == value
    end

    def to_s
      @name.to_s
    end
    
    def to_i
      @value.to_i
    end
    
  end
  
end
    