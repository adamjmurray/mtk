module MTK
  
  # A single numeric value that supports common numeric comparisons and operations
  
  class Scalar 

    include Comparable

    attr_reader :value
        
    def initialize(value)
      @value = value
    end

    def self.from_value(value)
      new(value)
    end

    # the nearest integer
    def to_i
      @value.round
    end  
    
    def to_f
      @value.to_f
    end  
    
    def <=> other
      @value <=> value_of(other)
    end

    def + param
     self.class.from_value( @value + value_of(param) )
    end

    def - param
      self.class.from_value( @value - value_of(param) )
    end

    def * param
      self.class.from_value( @value * value_of(param) )
    end

    def / param
      self.class.from_value( @value / value_of(param) )
    end

    def % param
      self.class.from_value( @value % value_of(param) )
    end
       
    def coerce(other)
      return [ self.class.from_value(value_of other), self ]
    end       
    
    ###########################################
    private
    
    def value_of( something )
      if something.is_a? Numeric
        return something
      else
        return value_of_compatible_type( something ) || raise(TypeError, "#{self.class} can't be coerced into #{other.class}")
      end
    end
    
    # return a compatible value after performing any needed conversions, otherwise nil if not compatible
    def value_of_compatible_type( something )      
      something.value if something.respond_to? :value
    end
    
  end  
end
