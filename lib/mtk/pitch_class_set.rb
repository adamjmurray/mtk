module MTK

  # A Set of PitchClasses, for 12-tone set-theory pitch analysis and manipulations
  #
  class PitchClassSet

    include Mappable

    attr_reader :pitch_classes
    
    def initialize(pitch_classes)
      @pitch_classes = pitch_classes.to_a.uniq.sort.freeze
    end

    def self.from_a enumerable
      new enumerable
    end

    def to_a
      Array.new(@pitch_classes)
    end

    def each &block
      @pitch_classes.each &block
    end

    def size
      @pitch_classes.size
    end

    def normal_order
      ordering = Array.new(@pitch_classes)
      min_span, start_index_for_normal_order = nil, nil

      # check every rotation for the minimal span:
      size.times do |index|
        span = self.class.span_for ordering

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

    def to_s
      @pitch_classes.join(' ')
    end

    def inspect
      @pitch_classes.inspect
    end

    def self.span_for(pitch_classes)
      span_between pitch_classes.first, pitch_classes.last
    end

    def self.span_between(pc1, pc2)
      (pc2.to_i - pc1.to_i) % 12
    end

  end
end
