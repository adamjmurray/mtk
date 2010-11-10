module Kreet

  # A frequency specified by a PitchClass and an octave
  
  class Pitch

    attr_reader :pitch_class, :octave

    def initialize( pitch_class, octave )
      @pitch_class, @octave = pitch_class, octave
    end    
    
    def self.from_midi( midi_number )
      pitch_class = PitchClasses::PITCH_CLASSES[midi_number % 12]
      octave = midi_number/12 - 1
      new( pitch_class, octave )
    end    
    
    def to_midi
      @value ||= @pitch_class.value + 12*(octave+1)
    end
    
    def value
      @value ||= to_midi
    end
    
    def ==( other ) 
      other.respond_to? :pitch_class and
       other.respond_to? :octave and
        other.pitch_class == pitch_class and other.octave == octave
    end
        
  end
  
end