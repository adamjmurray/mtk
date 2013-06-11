module MTK
  module Groups

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
      include PitchCollection

      attr_reader :pitches

      # @param pitches [#to_a] the collection of pitches
      # @see MTK#Melody
      #
      def initialize(pitches)
        @pitches = pitches.to_a.clone.freeze
      end

      def self.from_pitch_classes(pitch_classes, start=Constants::Pitches::C4, max_distance=12)
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

      # @param other [#pitches, Enumerable]
      def == other
        if other.respond_to? :pitches
          @pitches == other.pitches
        elsif other.is_a? Enumerable
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
        '[' + @pitches.map{|pitch| pitch.to_s}.join(', ') + ']'
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