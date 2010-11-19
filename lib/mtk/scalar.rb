module MTK
  
  # A single numeric value that supports common numeric comparisons and operations
  
  class Scalar 

    include Comparable

    attr_reader :value
        
    def initialize( value )
      @value = value
    end

    # the nearest integer
    def to_i
      @value.round
    end  
    
    def to_f
      @value.to_f
    end  
    
    def <=> other
      value <=> value_of( other )
    end

    def + param
      self.class.new( value + value_of(param) )
    end

    def - param
      self.class.new( value - value_of(param) )    
    end

    def * param
      self.class.new( value * value_of(param) )
    end

    def / param
      self.class.new( value / value_of(param) )
    end

    def % param
      self.class.new( value % value_of(param) )
    end
       
    def coerce(other)
      if other.is_a? Numeric
        return [ self.class.new( other ), self ]
      elsif other.respond_to? :to_f
        return [ self.class.new( other.to_f ), self ]
      else
        raise TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end       
    
    private
    def value_of( something )
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