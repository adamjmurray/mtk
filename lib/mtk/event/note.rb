module MTK

  module Event

    # A musical {Event} defined by a {Pitch}, intensity, and duration
    class Note < AbstractEvent

      # Frequency of the note as a {Pitch}.
      # This is an alias for #{AbstractEvent#number}
      attr_reader :pitch

      # Intensity of the note as a value in the range 0.0 - 1.0.
      # This is an alias for #{AbstractEvent#value}
      attr_reader :intensity

      def initialize(pitch, intensity, duration)
        @pitch, @intensity = pitch, intensity
        super(:note, intensity, duration, pitch)
      end

      def self.from_hash(hash)
        new (hash[:pitch] || hash[:number]), (hash[:intensity] || hash[:value]), hash[:duration]
      end

      def to_hash
        super.merge({ :pitch => pitch, :intensity => intensity })
      end

      def self.from_midi(pitch, velocity, duration_in_beats)
        new Pitches::PITCHES[pitch], velocity/127.0, duration_in_beats
      end

      def to_midi
        [pitch.to_i, velocity, duration]
      end

      # intensity scaled to the MIDI range 0-127
      def velocity
        @velocity ||= (127 * @intensity).round
      end

      def transpose(interval)
        self.class.new(@pitch+interval, @intensity, @duration)
      end

      def invert(around_pitch)
        self.class.new(@pitch.invert(around_pitch), @intensity, @duration)
      end

      def ==(other)
        ( other.respond_to? :pitch and @pitch == other.pitch and
          other.respond_to? :intensity and @intensity == other.intensity and
          other.respond_to? :duration and @duration == other.duration
        ) or super
      end

      def to_s
        "Note(#@pitch,#{sprintf '%.2f',@value},#{sprintf '%.2f',@duration})"
      end

      def inspect
        "Note(#{@pitch},#{@value},#{@duration})"
      end

    end
  end

  # Construct a {Note} from any supported type
  def Note(*anything)
    anything = anything.first if anything.size == 1
    case anything
      when Array then Event::Note.new(*anything)
      when Event::Note then anything
      else raise "Note doesn't understand #{anything.class}"
    end
  end
  module_function :Note

end
