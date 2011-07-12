module MTK

  module Event

    # A musical {Event} defined by a {Pitch}, intensity, and duration
    class Note < AbstractEvent

      # Frequency of the note as a {Pitch}.
      alias :pitch :number
      alias :pitch= :number=

      # Intensity of the note as a value in the range 0.0 - 1.0.
      alias :intensity :value
      alias :intensity= :value=

      # intensity scaled to the MIDI range 0-127
      alias :velocity :midi_value
      alias :velocity= :midi_value=

      def initialize(pitch, intensity, duration, channel=nil)
        super :note, :number => pitch, :value => intensity, :duration => duration, :channel => channel
      end

      def self.from_hash(hash)
        new (hash[:pitch] || hash[:number]), (hash[:intensity] || hash[:value]), hash[:duration], hash[:channel]
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

      def transpose(interval)
        self.pitch += interval
        self
      end

      def invert(around_pitch)
        self.pitch = self.pitch.invert(around_pitch)
        self
      end

      def ==(other)
        ( other.respond_to? :pitch and @pitch == other.pitch and
          other.respond_to? :intensity and @intensity == other.intensity and
          other.respond_to? :duration and @duration == other.duration
        ) or super
      end

      def to_s
        "Note(#@pitch, #{sprintf '%.2f',@value}, #{sprintf '%.2f',@duration})"
      end

      def inspect
        "Note(#{@pitch}, #{@value}, #{@duration})"
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
