module MTK

  # An ordered collection of {Pitch}es.
  #
  class PitchList

    include Helper::Collection
    include Transform::Mappable
    include Transform::Transposable
    include Transform::Invertible

    attr_reader :pitches


    # @param pitches [#to_a] the collection of pitches
    #
    # @note duplicate pitches will be removed. See #{PitchList} if you want to maintain duplicates.
    #
    # @see MTK#PitchSet
    # @see PitchList
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

    def to_pitch_class_list
      PitchClassList.new pitch_classes
    end

    def to_pitch_class_set
      PitchClassSet.new pitch_classes
    end

    def pitch_classes
      @pitch_classes ||= @pitches.map{|p| p.pitch_class }
    end

    # generate a chord inversion (positive numbers move the lowest notes up an octave, negative moves the highest notes down)
    # @note this process will sort the pitches
    def inversion(number)
      number = number.to_i
      pitch_set = Array.new(@pitches.uniq.sort)
      if number > 0
        number.times do |count|
          index = count % pitch_set.length
          pitch_set[index] += 12
        end
      else
        number.abs.times do |count|
          index = -(count + 1) % pitch_set.length # count from -1 downward to go backwards through the list starting at the end
          pitch_set[index] -= 12
        end
      end
      self.class.new pitch_set.sort
    end

    def nearest(pitch_class)
      self.transpose @pitches.first.pitch_class.distance_to(pitch_class)
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

  # Construct an ordered {PitchSet} that allows duplicates
  # @see #PitchSet
  # @see #Chord
  def PitchList(*anything)
    PitchList.new(Helper::Convert.to_pitches *anything)
  end
  module_function :PitchList

end