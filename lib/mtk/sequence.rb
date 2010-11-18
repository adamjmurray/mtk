module MTK

  # An ordered collection of items.
    
  class Sequence
    
    def initialize(*items)
      @items = items
    end
    
    def to_a
      @items
    end
    
  end
  
end