module MTK

  # An ordered collection of distinct {PitchClass}es, for 12-tone set-theory analysis and manipulations.
  #
  class PitchClassSet < PitchClassList

    # @param pitch_classes [#to_a] the collection of pitch classes
    #
    # @see PitchClassList
    # @see MTK#PitchClassSet
    #
    def initialize(pitch_classes)
      @pitch_classes = pitch_classes.to_a.clone
      @pitch_classes.uniq!
      @pitch_classes.freeze
    end
  end

  # Construct a {PitchClassSet} that doesn't contain duplicates
  # @see #PitchClassList
  def PitchClassSet(*anything)
    PitchClassSet.new(Helper::Convert.to_pitch_classes *anything)
  end
  module_function :PitchClassSet

end
