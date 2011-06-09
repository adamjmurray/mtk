module MTK::Transform

  # {Mappable} classes whose elements can handle the :transpose message
  # @note Classes including this module should include either MTK::Collection or provide a #first method
  module Invertible

    # Transpose all elements upward by the given interval
    # @param interval_in_semitones [Numeric] an interval in semitones
    def invert(inversion_point=first)
      map{|elem| elem.invert(inversion_point) }
    end

  end

end
