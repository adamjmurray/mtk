module MTK

  # A frequency represented by a {PitchClass}, an integer octave, and an offset in semitones.
  
  class Pitch < Frequency::Semitones

    attr_reader :pitch_class, :octave, :offset

    def initialize( pitch_class, octave, offset=0 )
      @pitch_class, @octave, @offset = pitch_class, octave, offset
    end    
    
    def self.[]( *args )
      args = args[0] if args.length == 1
      if args.is_a? Array
        pitch_class, octave = *args
        if pitch_class.kind_of? PitchClass and octave.kind_of? Numeric
          new( pitch_class, octave.to_i )
        end
      elsif args.respond_to? :to_semitones
        from_f( args.to_semitones )
      elsif args.is_a? Numeric
        from_f( args )
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
    
    # Convert a Numeric semitones value into a Pitch
    def self.from_f( f )
      i, offset = f.floor, f%1  # split into int and fractional part
      pitch_class = PitchClasses::PITCH_CLASSES[i % 12]
      octave = i/12 - 1
      new( pitch_class, octave, offset )      
    end      
    
    # Convert a Numeric semitones value into a Pitch    
    def self.from_i( i )
      self.from_f( i ) 
    end    
    
    def self.from_frequency( f )
      self.from_f( f.to_semitones )
    end
    
    # The numerical value of this pitch without the offset
    def base_value
      @pitch_class.to_i + 12*(@octave+1)
    end

    # The numerical value of this pitch
    def to_f
      base_value + @offset
    end 

    # The numerical value for the nearest semitone
    def to_i
      to_f.round
    end
    
    def offset_in_cents
      @offset * 100
    end
    
    def to_s
      "#@pitch_class#@octave" + if @offset.zero? then '' else "+#{offset_in_cents}cents" end
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