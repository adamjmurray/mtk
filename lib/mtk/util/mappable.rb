module MTK

  # Similar to Enumerable, but relies on the including Class's from_a method to
  # provide an implementation of #map which returns an object of the same type
  module Mappable
    include Enumerable

    alias enumerable_map map
    def map &block
      self.class.from_a(enumerable_map &block)
    end

  end
end
