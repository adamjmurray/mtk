module MTK

  module Groups

    # An ordered collection of {Core::PitchClass}es.
    #
    # Unlike a mathematical Set, a PitchClassSet is ordered and may contain duplicates.
    #
    # @see MTK::Groups::PitchGroup
    #
    class PitchClassGroup < Group

      def self.random_tone_row
        PitchClassGroup.new(MTK::Lang::PitchClasses::PITCH_CLASSES.shuffle)
      end


      alias pitch_classes elements

      # Convert to an Array of pitch_classes.
      alias to_pitch_classes to_a

      # Transpose all pitch classes upward by the given interval
      # @param interval_in_semitones [Numeric] an interval in semitones
      # @see Core::PitchClass#+
      def transpose(interval_in_semitones)
        map{|elem| elem + interval_in_semitones }
      end

      # Invert all elements around the given inversion point
      # @param inversion_point [Numeric] the value around which all elements will be inverted (defaults to the first element in the collection)
      def invert(inversion_point=first)
        map{|elem| elem.invert(inversion_point) }
      end

      # @param other [#pitch_classes, #to_a, Array]
      def == other
        if other.respond_to? :pitch_classes
          @elements == other.pitch_classes
        elsif other.respond_to? :to_a
          @elements == other.to_a
        else
          @elements == other
        end
      end

      # Compare for equality, ignoring order and duplicates
      # @param other [#pitch_classes, Array, #to_a]
      def =~ other
        @normalized_pitch_classes ||= @elements.uniq.sort
        @normalized_pitch_classes == case
          when other.respond_to?(:pitch_classes) then other.pitch_classes.uniq.sort
          when (other.is_a? Array and other.frozen?) then other
          when other.respond_to?(:to_a) then other.to_a.uniq.sort
          else other
        end
      end

      def to_s
        @elements.join(' ')
      end

      def inspect
        @elements.inspect
      end

    end
  end


  # Construct a {Groups::PitchClassGroup} from any supported type.
  def PitchClassGroup(*anything)
    MTK::Groups::PitchClassGroup.new(MTK::Groups.to_pitch_classes *anything)
  end
  module_function :PitchClassGroup

end
