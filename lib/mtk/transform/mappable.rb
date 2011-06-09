module MTK::Transform

  # Similar to Enumerable, but relies on the including Class's from_a method to
  # provide an implementation of #map which returns an object of the same type.
  #
  # @note Classes including this module should include either MTK::Collection or Enumerable
  #
  module Mappable
    include Enumerable

    # the original Enumerable#map implementation, which returns an Array
    alias enumerable_map map

    # the overriden #map implementation, which returns an object of the same type
    def map &block
      self.class.from_a(enumerable_map &block)
    end

  end

end
