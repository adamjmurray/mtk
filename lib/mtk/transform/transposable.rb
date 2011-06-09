module MTK::Transform

  # {Mappable} class whose elements can handle the :transpose message
  module Transposable

    # Transpose all elements upward by the given interval
    # @param interval_in_semitones [Numeric] an interval in semitones
    def transpose interval_in_semitones
      map{|elem| elem + interval_in_semitones }
    end

  end

end
