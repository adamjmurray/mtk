module MTK

  module Event

    # An abstract musical event that has an intensity and a duration
    # @abstract
    class AbstractEvent

      # The type of event, such as :note, :control, or :pressure
      attr_reader :type

      # The specific element effected by this type of event, when applicable.
      # Depends on the event type. For example, the number of a :note type Event is the pitch,
      # and the number of a :control type Event is the controller (CC) number.
      # This value is nil for inapplicable event types.
      attr_accessor :number

      # The value of event.
      # Depends on event type. For example, the value of a :note type Event is the intensity,
      # and the value of a :control type Event is the controller (CC) value.
      attr_accessor :value

      # Duration of the Event in beats (e.g. 1.0 is a quarter note in 4/4 time signatures)
      # @see length
      # @see rest?
      # @see instantaneous?
      # @see duration_in_pulses
      attr_accessor :duration

      # The channel of the event, for multi-tracked events.
      attr_accessor :channel


      def initialize(type, options={})
        @type = type
        @value = options[:value]
        @number = options[:number]
        @duration = options[:duration]
        @channel = options[:channel]
      end

      def self.from_hash(hash)
        new(hash[:type], hash)
      end

      def to_hash
        hash = {:type => @type}
        hash[:value] = @value unless @value.nil?
        hash[:duration] = @duration unless @duration.nil?
        hash[:number] = @number unless @number.nil?
        hash[:channel] = @channel unless @channel.nil?
        hash
      end

      def midi_value
        midi_value = (127 * (@value || 0)).round
        midi_value = 0 if midi_value < 0
        midi_value = 127 if midi_value > 127
        midi_value
      end

      def midi_value= value
        @value = value/127.0
      end

      # The magnitude (absolute value) of the duration.
      # Indicate the "real" duration for rests.
      # @see rest?
      def length
        (@duration || 0).abs
      end

      # By convention, any events with negative durations are a rest
      def rest?
        @duration < 0
      end

      # By convention, any events with 0 duration are instantaneous
      def instantaneous?
        @duration.nil? or @duration == 0
      end

      # Convert duration to an integer number of MIDI pulses, given the pulses_per_beat
      def duration_in_pulses(pulses_per_beat)
        (length * pulses_per_beat).round
      end

      def == other
        other.respond_to? :type and @type == other.type and
        other.respond_to? :number and @number == other.number and
        other.respond_to? :value and @value == other.value and
        other.respond_to? :duration and @duration == other.duration and
        other.respond_to? :channel and @channel == other.channel
      end

      def to_s
        "Event(#@type" + (@number ? "[#@number]" : '') + ", #{sprintf '%.2f',@value}, #{sprintf '%.2f',@duration})"
      end

      def inspect
        "Event(#@type" + (@number ? "[#@number]" : '') + ", #@value, #@duration)"
      end

    end

  end
end
