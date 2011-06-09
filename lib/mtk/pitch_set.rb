module MTK

  # A set of {Pitch}es
  #
  class PitchSet

    include Transform::Mappable
    include Transform::Transposable

    attr_reader :pitches

    def initialize(pitches)
      @pitches = pitches.to_a.uniq.sort.freeze
    end

    def self.from_a enumerable
      new enumerable
    end

    def to_a
      Array.new(@pitches)
    end

    def each &block
      @pitches.each &block
    end

    def to_pitch_class_set
      PitchClassSet.new @pitches.map{|p| p.pitch_class }
    end

    def pitch_classes
      @pitch_classes ||= @pitches.map{|p| p.pitch_class }.uniq
    end

    def invert(center_pitch=@pitches.first)
      map{|pitch| pitch.invert(center_pitch) }
    end

    # generate a chord inversion (positive numbers move the lowest notes up an octave, negative moves the highest notes down)
    def inversion(number)
      number = number.to_i
      pitch_set = Array.new(@pitches)
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
      self.class.new pitch_set
    end

    def include? pitch
      @pitches.include? pitch
    end

    def nearest(pitch_class)
      self.transpose @pitches.first.pitch_class.distance_to(pitch_class)
    end

    # @param other [#pitches, #to_a, Array]
    def == other
      if other.respond_to? :pitches
        @pitches == other.pitches
      elsif other.respond_to? :to_a
        @pitches == other.to_a
      else
        @pitches == other
      end
    end

    def to_s
      @pitches.inspect
    end

  end

  # Construct a {PitchSet} from any supported type
  def PitchSet(*anything)
    anything = anything.first if anything.size == 1
    case anything
      when Array then PitchSet.new(anything.map{|elem| Pitch(elem) })
      when PitchSet then anything
      else PitchSet.new([Pitch(anything)])
    end
  end
  module_function :PitchSet

end
