module MTK::Transform

  # {Mappable} class whose elements can handle the :invert message
  # @note Classes including this module should include either MTK::Collection or provide a #first method
  module Invertible

    # Invert all elements around the given inversion point
    # @param inversion_point [Numeric] the value around which all elements will be inverted (defaults to the first element in the collection)
    def invert(inversion_point=first)
      map{|elem| elem.invert(inversion_point) }
    end

  end

end
