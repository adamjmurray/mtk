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

      def self.from_midi(pitch, velocity, duration_in_beats, channel=0)
        new MTK::Constant::Pitches::PITCHES[pitch.to_i], velocity/127.0, duration_in_beats, channel
      end

      def midi_pitch
        pitch.to_i
      end

      def to_midi
        [midi_pitch, velocity, duration]
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
        ( other.respond_to? :pitch and pitch == other.pitch and
          other.respond_to? :intensity and intensity == other.intensity and
          other.respond_to? :duration and duration == other.duration
        ) or super
      end

      def to_s
        "Note(#@number, #{sprintf '%.2f',@value}, #{sprintf '%.2f',@duration})"
      end

      def inspect
        "Note(#{@number}, #{@value}, #{@duration})"
      end

    end
  end

  # Construct a {Event::Note} from any supported type
  def Note(*anything)
    anything = anything.first if anything.size == 1
    case anything
      when Array then MTK::Event::Note.new(*anything)
      when MTK::Event::Note then anything
      else raise "Note doesn't understand #{anything.class}"
    end
  end
  module_function :Note

end
