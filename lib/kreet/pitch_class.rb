module Kreet
  
  # A class of pitches under octave equivalence.
  #
  # A {Pitch} has the same PitchClass as the {Pitches} one or more octaves away.
  
  class PitchClass
    
    NAMES = ['C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B']
    
    VALID_NAMES = [
      ['B#',  'C',  'Dbb'],
      ['B##', 'C#', 'Db' ],
      ['C##', 'D',  'Ebb'],
      ['D#',  'Eb', 'Fbb'],
      ['D##', 'E',  'Fb' ],
      ['E#',  'F',  'Gbb'],
      ['E##', 'F#', 'Gb' ],
      ['F##', 'G',  'Abb'],
      ['G#',  'Ab'       ],
      ['G##', 'A',  'Bbb'],
      ['A#',  'Bb', 'Cbb'],
      ['A##', 'B',  'Cb' ]
    ]
    
    attr_reader :name

    ##########################################        
    private
    
    def initialize( name, int_value )
      @name, @int_value = name, int_value
    end     
    private_class_method :new

    @flyweight = {}
    def self.get( name, int_value )
      @flyweight[name] ||= new( name, int_value )
    end
    private_class_method :get

    ##########################################    
    public 
    
    def self.from_s( s )
      s = s.to_s
      s = s[0].upcase + s[1..-1].downcase # normalize the name      
      VALID_NAMES.each_with_index do |names, index|
        return get( s, index ) if names.include? s
      end  
      nil    
    end
    class << self
      alias from_name from_s # alias self.from_name to self.from_s
    end

    def self.from_i( value )
      value = value.to_i % 12
      name = NAMES[value]
      get( name, value )
    end
    
    def self.[]( name_or_value )
      if name_or_value.kind_of? Numeric 
        from_i( name_or_value )
      else 
        from_s( name_or_value )
      end
    end
    
    def ==( other )
      other.kind_of? PitchClass and other.to_i == @int_value
    end

    def to_s
      @name
    end
    
    def to_i
      @int_value
    end
    
    def +( interval )
      self.class.from_i( to_i + interval.to_i )
    end
    
    def -( interval )
      self.class.from_i( to_i - interval.to_i )
    end
  end
  
end
    