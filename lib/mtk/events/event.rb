module MTK

  module Events

    # An abstract musical event
    # @abstract
    class Event

      # The type of event: :note, :control, :pressure, :bend, or :program
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
      attr_reader :duration

      def duration= duration
        @duration = duration
        @duration = ::MTK::Core::Duration[@duration || 0] unless @duration.is_a? ::MTK::Core::Duration
        @duration
      end

      # The channel of the event, for multi-tracked events.
      attr_accessor :channel


      def initialize(type, options={})
        @type = type
        @value = options[:value]
        @number = options[:number]
        @duration = options.fetch(:duration, 0)
        @duration = ::MTK::Core::Duration[@duration] unless @duration.is_a? ::MTK::Core::Duration
        @channel = options[:channel]
      end

      def self.from_h(hash)
        new(hash[:type], hash)
      end

      def to_h
        hash = {type: @type}
        hash[:value] = @value unless @value.nil?
        hash[:duration] = @duration unless @duration.nil?
        hash[:number] = @number unless @number.nil?
        hash[:channel] = @channel unless @channel.nil?
        hash
      end

      def midi_value
        if @value and @value.respond_to? :to_midi
          @value.to_midi
        else
          value = @value
          midi_value = (127 * (value || 0)).round
          midi_value = 0 if midi_value < 0
          midi_value = 127 if midi_value > 127
          midi_value
        end
      end

      def midi_value= value
        @value = value/127.0
      end

      # The magnitude (absolute value) of the duration.
      # Indicate the "real" duration for rests.
      # @see rest?
      def length
        @duration.length
      end

      # True if this event represents a rest, false otherwise.
      # By convention, any events with negative durations are a rest
      def rest?
        @duration.rest?
      end

      # By convention, any events with 0 duration are instantaneous
      def instantaneous?
        @duration.nil? or @duration == 0
      end

      # Convert duration to an integer number of MIDI pulses, given the pulses_per_beat
      def duration_in_pulses(pulses_per_beat)
        (length.to_f * pulses_per_beat).round
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
        "Event(#@type" + (@number ? "[#@number]" : '') + ", #@value, #{@duration.to_f})"
      end

    end

  end
end
