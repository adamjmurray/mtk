module MTK
 module Frequency

  # A frequency represented by a {PitchClass}, an integer octave, and an offset in semitones.
  
  class Pitch < Semitones

    attr_reader :pitch_class, :octave, :offset

    def initialize( pitch_class, octave, offset=0 )
      @pitch_class, @octave, @offset = pitch_class, octave, offset
      @value = @pitch_class.to_i + 12*(@octave+1) + @offset
    end
    
    def self.[]( *args )
      args = args[0] if args.length == 1
      if args.is_a? Array
        pitch_class, octave = *args
        if pitch_class.kind_of? PitchClass and octave.kind_of? Numeric
          new( pitch_class, octave.to_i )
        end
      elsif args.respond_to? :to_semitones
        from_f( args.to_semitones.to_f )
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
      from_f( i )
    end    
    
    def self.from_frequency( f )
      from_f( f.to_semitones.to_f )
    end

    def self.from_value(value)
      from_f(value.to_f)
    end

    # The numerical value of this pitch
    def to_f
      @value
    end 

    # The numerical value for the nearest semitone
    def to_i
      @value.round
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

    def value_of_compatible_type( something )
      puts "PITCH CONVERTING #{something} to semitones"
      puts "value is #{something.to_semitones.value}"
      something.to_semitones if something.respond_to? :to_semitones
    end

  end
 end
end
