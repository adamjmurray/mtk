module MTK

  # An ordered collection of {PitchClass}es.
  #
  # Unlike a mathematical Set, a PitchClassSet is ordered and may contain duplicates.
  #
  # @see Melody
  # @see Chord
  #
  class PitchClassSet
    include Helper::PitchCollection

    attr_reader :pitch_classes

    def self.random_row
      new(Constant::PitchClasses::PITCH_CLASSES.shuffle)
    end

    def self.all
      @all ||= new(Constant::PitchClasses::PITCH_CLASSES)
    end

    # @param pitch_classes [#to_a] the collection of pitch classes
    #
    # @see MTK#PitchClassSet
    #
    def initialize(pitch_classes)
      @pitch_classes = pitch_classes.to_a.clone.freeze
    end

    # @see Helper::Collection
    def elements
      @pitch_classes
    end

    # Convert to an Array of pitch_classes.
    # @note this returns a mutable copy the underlying @pitch_classes attribute, which is otherwise unmutable
    alias :to_pitch_classes :to_a

    def self.from_a enumerable
      new enumerable
    end

    def normal_order
      ordering = Array.new(@pitch_classes.uniq.sort)
      min_span, start_index_for_normal_order = nil, nil

      # check every rotation for the minimal span:
      size.times do |index|
        span = self.class.span_between ordering.first, ordering.last

        if min_span.nil? or span < min_span
          # best so far
          min_span = span
          start_index_for_normal_order = index

        elsif span == min_span
          # handle ties, minimize distance between first and second-to-last note, then first and third-to-last, etc
          span1, span2 = nil, nil
          tie_breaker = 1
          while span1 == span2 and tie_breaker < size
            span1 = self.class.span_between( ordering[0], ordering[-1 - tie_breaker] )
            span2 = self.class.span_between( ordering[start_index_for_normal_order], ordering[start_index_for_normal_order - tie_breaker] )
            tie_breaker -= 1
          end
          if span1 != span2
            # tie cannot be broken, pick the one starting with the lowest pitch class
            if ordering[0].to_i < ordering[start_index_for_normal_order].to_i
              start_index_for_normal_order = index
            end
          elsif span1 < span2
            start_index_for_normal_order = index
          end

        end
        ordering << ordering.shift  # rotate
      end

      # we've rotated all the way around, so we now need to rotate back to the start index we just found:
      start_index_for_normal_order.times{ ordering << ordering.shift }

      ordering
    end

    def normal_form
      norder = normal_order
      first_pc_val = norder.first.to_i
      norder.map{|pitch_class| (pitch_class.to_i - first_pc_val) % 12 }
    end

    # the collection of elements present in both sets
    def intersection(other)
      self.class.from_a(to_a & other.to_a)
    end

    # the collection of all elements present in either set
    def union(other)
      self.class.from_a(to_a | other.to_a)
    end

    # the collection of elements from this set with any elements from the other set removed
    def difference(other)
      self.class.from_a(to_a - other.to_a)
    end

    # the collection of elements that are members of exactly one of the sets
    def symmetric_difference(other)
      union(other).difference( intersection(other) )
    end

    # the collection of elements that are not members of this set
    # @note this method requires that the including class define the class method .all(), which returns the collection of all possible elements
    def complement
      self.class.all.difference(self)
    end

    # @param other [#pitch_classes, #to_a, Array]
    def == other
      if other.respond_to? :pitch_classes
        @pitch_classes == other.pitch_classes
      elsif other.respond_to? :to_a
        @pitch_classes == other.to_a
      else
        @pitch_classes == other
      end
    end

    # Compare for equality, ignoring order and duplicates
    # @param other [#pitch_classes, Array, #to_a]
    def =~ other
      @normalized_pitch_classes ||= @pitch_classes.uniq.sort
      @normalized_pitch_classes == case
        when other.respond_to?(:pitch_classes) then other.pitch_classes.uniq.sort
        when (other.is_a? Array and other.frozen?) then other
        when other.respond_to?(:to_a) then other.to_a.uniq.sort
        else other
      end
    end

    def to_s
      @pitch_classes.join(' ')
    end

    def inspect
      @pitch_classes.inspect
    end

    def self.span_between(pc1, pc2)
      (pc2.to_i - pc1.to_i) % 12
    end

  end


  # Construct a {PitchClassSet}
  # @see PitchClassSet#initialize
  def PitchClassSet(*anything)
    PitchClassSet.new(Helper::Convert.to_pitch_classes *anything)
  end
  module_function :PitchClassSet

end
