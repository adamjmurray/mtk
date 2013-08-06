module MTK
  module Groups

    # An unordered collection of distinct {Pitch}es.
    #
    # Represents a "vertical" (simultaneous) pitch collection.
    # This is unordered in the sense that the order provided is ignored. The pitches are sorted to normalize the chord.
    #
    class Chord < PitchGroup

      # @param pitches [#to_a] the collection of {Pitch}es
      # @note duplicate pitches will be removed and the collection will be sorted.
      #       See #{PitchGroup} if you want to maintain the original pitches.
      #
      def initialize(pitches)
        super pitches.to_a.uniq.sort
      end

      # Generate a chord inversion (positive numbers move the lowest notes up an octave, negative moves the highest notes down)
      def inversion(number)
        number = number.to_i
        pitch_set = Array.new(@elements.uniq.sort)
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
        self.transpose @elements.first.pitch_class.distance_to(pitch_class)
      end
    end
  end

  # Construct an ordered {MTK::Groups::Chord} with no duplicates.
  # @see #MTK::Groups::Chord
  def Chord(*anything)
    MTK::Groups::Chord.new MTK::Groups.to_pitches(*anything)
  end
  module_function :Chord

end
