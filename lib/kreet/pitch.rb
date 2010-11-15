module Kreet

  # A frequency specified by a PitchClass and an octave
  
  class Pitch

    attr_reader :pitch_class, :octave

    def initialize( pitch_class, octave )
      @pitch_class, @octave = pitch_class, octave
    end    
    
    def self.from_i( i )
      i = i.to_i
      pitch_class = PitchClasses::PITCH_CLASSES[i % 12]
      octave = i/12 - 1
      new( pitch_class, octave )
    end    
    
    def to_i
      @int_value ||= @pitch_class.to_i + 12*(octave+1)
    end 
    
    def ==( other )
      other.respond_to? :pitch_class and other.respond_to? :octave and
      other.pitch_class == pitch_class and other.octave == octave      
    end
    
    def +( interval )
      self.class.from_i( to_i + interval.to_i )
    end
      
    def -( interval )
      self.class.from_i( to_i - interval.to_i )
    end
        
  end
  
end