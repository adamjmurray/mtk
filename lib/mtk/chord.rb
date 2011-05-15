module MTK

  # A sorted list of distinct pitches
  class Chord < PitchList

    def initialize(pitches)
      @pitches = pitches.clone.sort.uniq.freeze
    end

    def inversion(number)
      number = number.to_i
      pitch_list = Array.new @pitches
      if number > 0
        number.times do |count|
          index = count % pitch_list.length
          pitch_list[index] += 12
        end
      else
        number.abs.times do |count|
          index = -(count + 1) % pitch_list.length # count from -1 downward to go backwards through the list starting at the end
          pitch_list[index] -= 12
        end
      end
      self.class.new pitch_list
    end

  end

end
