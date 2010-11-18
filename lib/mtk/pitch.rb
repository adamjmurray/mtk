module MTK

  # A logarithmic representation of frequency 
  # specified by a {PitchClass}, an integer octave, and an offset in fractional semitones.
  
  class Pitch

    attr_reader :pitch_class, :octave, :offset

    def initialize( pitch_class, octave, offset=0 )
      @pitch_class, @octave, @offset = pitch_class, octave, offset
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
      # TODO: update to handle offset
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
    
    def self.from_f( f )
      i, offset = f.floor, f%1  # split into int and fractional part
      pitch_class = PitchClasses::PITCH_CLASSES[i % 12]
      octave = i/12 - 1
      new( pitch_class, octave, offset )      
    end      
    
    def self.from_i( i )
      self.from_f( i ) 
    end    
    
    def self.from_cents( cents )
      self.from_f( cents/100.0 )
    end
    
    # The numerical value of this pitch without the offset
    def base_value
      @base_value ||= @pitch_class.to_i + 12*(@octave+1)
    end

    # The numerical value of this pitch
    def to_f
      @float_value ||= base_value + @offset
    end 

    # The numerical value for the nearest semitone
    def to_i
      @int_value ||= to_f.round
    end
    
    def to_cents
      to_f * 100
    end
    
    def offset_in_cents
      @offset * 100
    end
    
    def to_s
      @s ||= "#@pitch_class#@octave" + if @offset.zero? then '' else "+#{offset_in_cents}cents" end
    end
    
    def ==( other )
      other.respond_to? :pitch_class and other.respond_to? :octave and
      other.pitch_class == pitch_class and other.octave == octave      
    end
    
    def +( interval )
      self.class.from_f( to_f + interval.to_f )
    end
      
    def -( interval )
      self.class.from_f( to_f - interval.to_f )
    end
              
  end
  
end