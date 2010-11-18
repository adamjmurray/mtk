module MTK

  # A frequency specified by a {PitchClass} and an integer octave.
  
  class Pitch

    attr_reader :pitch_class, :octave

    def initialize( pitch_class, octave )
      @pitch_class, @octave = pitch_class, octave
    end    
    
    def self.[]( *args )
      args = args[0] if args.length == 1
      case args
      when Array
        pitch_class, octave = *args
        if pitch_class.kind_of? PitchClass and octave.kind_of? Numeric
          new( pitch_class, octave.to_i )
        end
      when Numeric
        from_i( args )
      else
        from_s( args )
      end
    end
    
    def self.from_s( s )
      s = s.to_s
      s = s[0].upcase + s[1..-1].downcase # normalize name
      if s =~ /^([A-G](#|##|b|bb)?)(-?\d+)$/
        pitch_class = PitchClass.from_s($1)
        if pitch_class
          octave = $3.to_i
          new( pitch_class, octave )
        end
      end
    end
    
    def self.from_i( i )
      i = i.to_i
      pitch_class = PitchClasses::PITCH_CLASSES[i % 12]
      octave = i/12 - 1
      new( pitch_class, octave )
    end    
    
    def to_i
      @int_value ||= @pitch_class.to_i + 12*(@octave+1)
    end 
    
    def to_s
      "#@pitch_class#@octave"
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