module Kreet
  
  # A numeric value that supports common numeric comparisons and operations
  
  class Value 

    attr_reader :value
        
    def initialize( value )
      @value = value
    end

    def to_i
      @value.round
    end  
    
    def to_f
      @value.to_f
    end  

    def == other
      value == Value.of( other )
    rescue
      false
    end
    
    def <=> other
      value <=> Value.of( other )
    end

    include Comparable
    
    def + param
      self.class.new( value + Value.of( param ))
    end

    def - param
      self.class.new( value - Value.of( param ))    
    end

    def * param
      self.class.new( value * Value.of( param ))
    end

    def / param
      self.class.new( value / Value.of( param ))
    end

    def % param
      self.class.new( value % Value.of( param ))
    end
       
    def self.of something
      if something.is_a? Numeric
        something
      elsif something.respond_to? :value        
        something.value
      else
        nil
      end
    end
    
  end
  
end