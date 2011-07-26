module MTK

  # An ordered collection of {Pitch}es.
  #
  # The "horizontal" (sequential) pitch collection.
  #
  # Unlike the strict definition of melody, this class is fairly abstract and only models a succession of pitches.
  # To create a true, playable melody one must combine an MTK::Melody and rhythms into a {Timeline}.
  #
  # @see Chord
  #
  class Melody
    include Helper::PitchCollection

    attr_reader :pitches

    # @param pitches [#to_a] the collection of pitches
    # @see MTK#Melody
    #
    def initialize(pitches)
      @pitches = pitches.to_a.clone.freeze
    end

    # @see Helper::Collection
    def elements
      @pitches
    end

    # Convert to an Array of pitches.
    # @note this returns a mutable copy the underlying @pitches attribute, which is otherwise unmutable
    alias :to_pitches :to_a

    def self.from_a enumerable
      new enumerable
    end

    def to_pitch_class_set(remove_duplicates=true)
      PitchClassSet.new(remove_duplicates ? pitch_classes.uniq : pitch_classes)
    end

    def pitch_classes
      @pitch_classes ||= @pitches.map{|p| p.pitch_class }
    end

    # @param other [#pitches, #to_a, Array]
    def == other
      if other.respond_to? :pitches
        @pitches == other.pitches
      elsif other.respond_to? :to_a
        @pitches == other.to_a
      else
        @pitches == other
      end
    end

    # Compare for equality, ignoring order and duplicates
    # @param other [#pitches, Array, #to_a]
    def =~ other
      @normalized_pitches ||= @pitches.uniq.sort
      @normalized_pitches == case
        when other.respond_to?(:pitches) then other.pitches.uniq.sort
        when (other.is_a? Array and other.frozen?) then other
        when other.respond_to?(:to_a) then other.to_a.uniq.sort
        else other
      end
    end

    def to_s
      @pitches.inspect
    end

  end

  # Construct an ordered {Melody} that allows duplicates
  # @see #Melody
  # @see #Chord
  def Melody(*anything)
    Melody.new(Helper::Convert.to_pitches *anything)
  end
  module_function :Melody

end