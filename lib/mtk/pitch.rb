module MTK

  # A frequency represented by a {PitchClass}, an integer octave, and an offset in semitones.
  class Pitch

    include Comparable

    attr_reader :pitch_class, :octave, :offset

    def initialize( pitch_class, octave, offset=0 )
      @pitch_class, @octave, @offset = pitch_class, octave, offset
      @value = @pitch_class.to_i + 12*(@octave+1) + @offset
    end

    @flyweight = {}

    # Return a pitch with no offset, only constructing a new instance when not already in the flyweight cache
    def self.[](pitch_class, octave)
      pitch_class = MTK.PitchClass(pitch_class)
      @flyweight[[pitch_class,octave]] ||= new(pitch_class, octave)
    end

    # Lookup a pitch by name, which consists of any {PitchClass::VALID_NAMES} and an octave number.
    # The name may also be optionally suffixed by +/-###cents (where ### is any number).
    # @example get the Pitch for middle C :
    #         Pitch.from_s('C4')
    # @example get the Pitch for middle C + 50 cents:
    #         Pitch.from_s('C4+50cents')
    def self.from_s( name )
      s = name.to_s
      s = s[0..0].upcase + s[1..-1].downcase # normalize name
      if s =~ /^([A-G](#|##|b|bb)?)(-?\d+)(\+(\d+(\.\d+)?)cents)?$/
        pitch_class = PitchClass.from_s($1)
        if pitch_class
          octave = $3.to_i
          offset_in_cents = $5.to_f
          if offset_in_cents.nil? or offset_in_cents.zero?
            return self[pitch_class, octave]
          else
            return new( pitch_class, octave, offset_in_cents/100.0 )
          end
        end
      end
      raise ArgumentError.new("Invalid pitch name: #{name.inspect}")
    end

    class << self
      alias :from_name :from_s
    end
    
    # Convert a Numeric semitones value into a Pitch
    def self.from_f( f )
      i, offset = f.floor, f%1  # split into int and fractional part
      pitch_class = PitchClass.from_i(i)
      octave = i/12 - 1
      if offset == 0
        self[pitch_class, octave]
      else
        new( pitch_class, octave, offset )
      end
    end

    def self.from_hash(hash)
      new hash[:pitch_class], hash[:octave], hash.fetch(:offset,0)
    end
    
    # Convert a Numeric semitones value into a Pitch    
    def self.from_i( i )
      from_f( i )
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

    def to_hash
      {:pitch_class => @pitch_class, :octave => @octave, :offset => @offset}
    end

    def to_s
      "#{@pitch_class}#{@octave}" + (@offset.zero? ? '' : "+#{offset_in_cents.round}cents")
    end

    def inspect
      "#<#{self.class}:#{object_id} @value=#{@value}>"
    end

    def ==( other )
      other.respond_to? :pitch_class and other.respond_to? :octave and other.respond_to? :offset and
      other.pitch_class == @pitch_class and other.octave == @octave and other.offset == @offset
    end

    def <=> other
      @value <=> other.to_f
    end

    def + interval_in_semitones
     self.class.from_f( @value + interval_in_semitones.to_f )
    end
    alias transpose +

    def - interval_in_semitones
      self.class.from_f( @value - interval_in_semitones.to_f )
    end

    def invert(center_pitch)
      self + 2*(center_pitch.to_f - to_f)
    end

    def nearest(pitch_class)
      self + self.pitch_class.distance_to(pitch_class)
    end

    def coerce(other)
      return self.class.from_f(other.to_f), self
    end

    def clone_with(hash)
      self.class.from_hash(to_hash.merge hash)
    end

  end

  # Construct a {Pitch} from any supported type
  def Pitch(*anything)
    anything = anything.first if anything.length == 1
    case anything
      when Numeric then Pitch.from_f(anything)
      when String, Symbol then Pitch.from_s(anything)
      when Pitch then anything
      when Array
        if anything.length == 2
          Pitch[*anything]
        else
          Pitch.new(*anything)
        end
      else raise ArgumentError.new("Pitch doesn't understand #{anything.class}")
    end
  end
  module_function :Pitch

end
