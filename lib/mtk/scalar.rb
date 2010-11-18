module MTK
  
  # A single numeric value that supports common numeric comparisons and operations
  
  class Scalar 

    include Comparable

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
    
    def <=> other
      value <=> Scalar.value_of( other )
    end

    def + param
      self.class.new( value + Scalar.value_of( param ))
    end

    def - param
      self.class.new( value - Scalar.value_of( param ))    
    end

    def * param
      self.class.new( value * Scalar.value_of( param ))
    end

    def / param
      self.class.new( value / Scalar.value_of( param ))
    end

    def % param
      self.class.new( value % Scalar.value_of( param ))
    end
       
    def self.value_of( something )
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