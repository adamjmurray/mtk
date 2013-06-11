module MTK
  module Groups

    # A sorted collection of distinct {Pitch}es.
    #
    # The "vertical" (simultaneous) pitch collection.
    #
    # @see Melody
    # @see PitchClassSet
    #
    class Chord < Melody

      # @param pitches [#to_a] the collection of pitches
      # @note duplicate pitches will be removed. See #{Melody} if you want to maintain duplicates.
      #
      def initialize(pitches)
        pitches = pitches.to_a.clone
        pitches.uniq!
        pitches.sort!
        @pitches = pitches.freeze
      end

      # Generate a chord inversion (positive numbers move the lowest notes up an octave, negative moves the highest notes down)
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

      # Transpose the chord so that it's lowest pitch is the given pitch class.
      def nearest(pitch_class)
        self.transpose @pitches.first.pitch_class.distance_to(pitch_class)
      end
    end
  end

  # Construct an ordered {MTK::Groups::Chord} with no duplicates.
  # @see #MTK::Groups::Chord
  # @see #MTK::Groups::Melody
  def Chord(*anything)
    MTK::Groups::Chord.new MTK::Groups.to_pitches(*anything)
  end
  module_function :Chord

end
