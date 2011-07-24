module MTK

  # An ordered collection of distinct {Pitch}es.
  #
  class PitchSet < PitchList

    # @param pitches [#to_a] the collection of pitches
    #
    # @note duplicate pitches will be removed. See #{PitchList} if you want to maintain duplicates.
    #
    # @see MTK#PitchSet
    # @see PitchList
    #
    def initialize(pitches)
      pitches = pitches.to_a.clone
      pitches.uniq!
      @pitches = pitches.freeze
    end
  end

  # Construct an ordered {PitchSet} with no duplicates.
  # @see #Chord
  # @see #PitchList
  def PitchSet(*anything)
    PitchSet.new(Helper::Convert.to_pitches *anything)
  end
  module_function :PitchSet

end
