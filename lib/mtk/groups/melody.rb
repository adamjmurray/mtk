module MTK
  module Groups

    # An ordered collection of {Pitch}es.
    #
    # The "horizontal" (sequential) pitch collection.
    #
    # Unlike the strict definition of melody, this class is fairly abstract and only models a succession of pitches.
    # To create a true, playable melody one must combine an MTK::Melody and rhythms into a {Events::Timeline}.
    #
    # @see Chord
    #
    class Melody < Group

      alias pitches elements

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

      def to_pitch_class_set(remove_duplicates=true)
        PitchClassSet.new(remove_duplicates ? pitch_classes.uniq : pitch_classes)
      end

      def pitch_classes
        @pitch_classes ||= @elements.map{|p| p.pitch_class }
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

  # Construct an ordered {MTK::Groups::Melody} that allows duplicates
  # @see #MTK::Groups::Melody
  # @see #MTK::Groups::Chord
  def Melody(*anything)
    MTK::Groups::Melody.new MTK::Groups.to_pitches(*anything)
  end
  module_function :Melody

end