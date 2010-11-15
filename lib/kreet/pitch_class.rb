module Kreet
  
  # A class of pitches under octave equivalence.
  # Pitches one or more octaves away from each other have the same pitch class.
  
  class PitchClass
    
    NAMES = ['C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B']
    
    attr_reader :name

    #####################    
    private

    @flyweight = []

    attr_reader :int_value

    private_class_method :new

    def initialize( name, int_value )
      @name, @int_value = name, int_value
    end     
       

    #####################    
    public 
    
    def self.from_name( name )
      name = name.to_s
      value = NAMES.index(name)
      if value
        @flyweight[value] ||= new( name, value )
      end
    end

    def self.from_i( value )
      value = value.to_i % 12
      @flyweight[value] ||= new( NAMES[value], value )
    end
    
    def self.[]( name_or_value )
      if name_or_value.kind_of? Numeric 
        from_i( name_or_value )
      else 
        from_name( name_or_value )
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
    