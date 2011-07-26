module MTK::Helper

  # An extension to {Collection}, which provides additional transformations for pitch-like collections.
  #
  module PitchCollection
    include Collection

    # Transpose all elements upward by the given interval
    # @param interval_in_semitones [Numeric] an interval in semitones
    def transpose interval_in_semitones
      map{|elem| elem + interval_in_semitones }
    end

    # Invert all elements around the given inversion point
    # @param inversion_point [Numeric] the value around which all elements will be inverted (defaults to the first element in the collection)
    def invert(inversion_point=first)
      map{|elem| elem.invert(inversion_point) }
    end

  end

end