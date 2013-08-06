module MTK
  module Groups

    # An ordered collection of {Pitch}es.
    #
    # @see PitchClassGroup
    #
    class PitchGroup < Group

      alias pitches elements

      # Given an optional starting pitch and max distance from that pitch, construct a PitchGroup from a
      # list of {PitchClass}es.
      def self.from_pitch_classes(pitch_classes, start=MTK::Lang::Pitches::C4, max_distance=12)
        pitch = start
        pitches = []
        pitch_classes.each do |pitch_class|
          pitch = pitch.nearest(pitch_class)
          pitch -= 12 if pitch > start+max_distance # keep within max_distance of start (default is one octave)
          pitch += 12 if pitch < start-max_distance
          pitches << pitch
        end
        new pitches
      end

      # Convert to an Array of pitches.
      alias to_pitches to_a

      def pitch_classes
        @pitch_classes ||= @elements.map{|p| p.pitch_class }
      end

      # Convert this PitchGroup to a {PitchClassGroup} using the {PitchClass} of each {Pitch} in this collection.
      def to_pitch_class_group
        PitchClassGroup.new(pitch_classes)
      end

      # Convert this PitchGroup to a {PitchClassSet} using the {PitchClass} of each {Pitch} in this collection.
      def to_pitch_class_set
        PitchClassSet.new(pitch_classes)
      end

      # Transpose all elements upward by the given interval
      # @param interval_in_semitones [Numeric] an interval in semitones
      def transpose(interval_in_semitones)
        map{|elem| elem + interval_in_semitones }
      end

      # Invert all elements around the given inversion point
      # @param inversion_point [Numeric] the value around which all elements will be inverted (defaults to the first element in the collection)
      def invert(inversion_point=first)
        map{|elem| elem.invert(inversion_point) }
      end

      # @param other [#pitches, Enumerable]
      def == other
        if other.respond_to? :pitches
          @elements == other.pitches
        elsif other.is_a? Enumerable
          @elements == other.to_a
        else
          @elements == other
        end
      end

      # Compare for equality, ignoring order and duplicates
      # @param other [#pitches, Array, #to_a]
      def =~ other
        @normalized_pitches ||= @elements.uniq.sort
        @normalized_pitches == case
          when other.respond_to?(:pitches) then other.pitches.uniq.sort
          when (other.is_a? Array and other.frozen?) then other
          when other.respond_to?(:to_a) then other.to_a.uniq.sort
          else other
        end
      end

      def to_s
        '[' + @elements.map{|pitch| pitch.to_s}.join(', ') + ']'
      end

    end
  end

  # Construct a {MTK::Groups::PitchGroup} from any supported type
  # @see #MTK::Groups::PitchGroup
  def PitchGroup(*anything)
    MTK::Groups::PitchGroup.new MTK::Groups.to_pitches(*anything)
  end
  module_function :PitchGroup

end