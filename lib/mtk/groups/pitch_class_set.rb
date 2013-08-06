module MTK

  module Groups

    # An unordered collection of distinct {PitchClass}es.
    #
    # This is unordered in the sense that the given order is ignored.
    # The pitch classes are sorted to create a canonical form for the collection.
    # Note: that musical set theory provides different forms of "normalization" besides this canonical sorted form,
    # including {#normal_order} and {#normal_form}
    #
    class PitchClassSet < PitchClassGroup

      def self.all
        @all ||= new(MTK::Lang::PitchClasses::PITCH_CLASSES)
      end


      # @param pitch_classes [#to_a] the collection of {PitchClass}es
      # @note duplicate pitches will be removed and the collection will be sorted.
      #       See #{PitchGroup} if you want to maintain the original pitches.
      #
      def initialize(pitch_classes)
        super pitch_classes.to_a.uniq.sort
      end


      def normal_order
        ordering = Array.new(@elements.uniq.sort)
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
      def complement
        self.class.all.difference(self)
      end


      def self.span_between(pc1, pc2)
        (pc2.to_i - pc1.to_i) % 12
      end

    end
  end

  # Construct a {Groups::PitchClassSet} from any supported type.
  def PitchClassSet(*anything)
    MTK::Groups::PitchClassSet.new(MTK::Groups.to_pitch_classes *anything)
  end
  module_function :PitchClassSet

end
