module MTK

  # An immutable collection of {Pitch}es.
  # @note Unlike a mathematical set, a PitchSet is ordered and may include duplicates (see {#initialize} options).
  class PitchSet

    include Helper::Collection
    include Transform::Mappable
    include Transform::Transposable
    include Transform::Invertible

    attr_reader :pitches

    # @param pitches [#to_a] the collection of pitches
    # @param options [Hash] options for modifying the collection of pitches
    # @option options :unique when not false, duplicate pitches will be removed
    # @option options :uniq alias for the :unique option
    # @option options :sort when not false, the pitches will be sorted
    def initialize(pitches, options=nil)
      pitches = pitches.to_a.clone
      pitches.uniq! if options and (options[:unique] or options[:uniq])
      pitches.sort! if options and options[:sort]
      @pitches = pitches.freeze
    end

    def elements
      @pitches
    end

    def self.from_a enumerable
      new enumerable
    end

    def to_pitch_class_set
      PitchClassSet.new @pitches.map{|p| p.pitch_class }
    end

    def pitch_classes
      @pitch_classes ||= @pitches.map{|p| p.pitch_class }.uniq
    end

    # generate a chord inversion (positive numbers move the lowest notes up an octave, negative moves the highest notes down)
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
      self.class.new pitch_set, :sort => true
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
