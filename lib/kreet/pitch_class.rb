module Kreet
  
  # A class of pitches under octave equivalence.
  # Pitches one or more octaves away from each other have the same pitch class.
  
  class PitchClass
    
    Names = ['C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B']
    
    attr_reader :name, :value

    #####################    
    private

    @flyweight = []

    private_class_method :new

    def initialize( name, value )
      @name, @value = name, value
    end        

    #####################    
    public 
    
    def self.from_name( name )
      value = Names.index(name.to_s)
      if value
        @flyweight[value] ||= new( name, value )
      end
    end

    def self.from_value( value )
      value = value.to_i % 12
      name = Names[value]
      @flyweight[value] ||= new( name, value )
    end
    
    def self.[]( name_or_value )
      if name_or_value.kind_of? Numeric 
        from_value( name_or_value )
      else 
        from_name( name_or_value )
      end
    end
    
    def ==( other )
      other.respond_to? :name and other.respond_to? :value and
      other.name == name and other.value == value
    end

    def to_s
      @name.to_s
    end
    
    def to_i
      @value.to_i
    end
    
    def +( other )
      self.class.from_value( to_i + other.to_i )
    end
    
    def -( other )
      self.class.from_value( to_i - other.to_i )
    end
  end
  
end
    