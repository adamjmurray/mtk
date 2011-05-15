module MTK

  # A Set of PitchClasses, for 12-tone set-theory pitch analysis and manipulations

  class PitchClassSet

    def initialize(pitch_classes)
      @pitch_classes = pitch_classes.uniq.sort.freeze
    end

    def size
      @pitch_classes.size
    end

    def normal_order
      ordering = Array.new(@pitch_classes)
      min_span, first_pitch_class_for_normal_order = nil, nil
      # check every rotation for the minimal span:
      size.times do
        span = PitchClassSet.span_for ordering
        if min_span.nil? or span < min_span
          min_span = span
          first_pitch_class_for_normal_order = ordering.first
        elsif span == min_span
          # TODO: handle ties, minimize distance between first and second-to-last note,
          # then first and third-to-last, etc
        end
        ordering << ordering.shift  # rotate
      end
      ordering << ordering.shift until ordering.first == first_pitch_class_for_normal_order
      ordering
    end

    def normal_form
      norder = normal_order
      first_pc_val = norder.first.to_i
      norder.map{|pitch_class| (pitch_class.to_i - first_pc_val) % 12 }
    end

    def ==(other)
      @pitch_classes == other
    end

    def to_s
      @pitch_classes.join(' ')
    end

    def inspect
      @pitch_classes.inspect
    end

    def self.span_for(pitch_classes)
      (pitch_classes.last.to_i - pitch_classes.first.to_i) % 12
    end

  end
end
