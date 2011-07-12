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
      attr_reader :number

      # The value of event.
      # Depends on event type. For example, the value of a :note type Event is the intensity,
      # and the value of a :control type Event is the controller (CC) value.
      attr_reader :value

      def initialize(type, value, duration, number=nil)
        @type, @value, @duration, @number = type, value, duration, number
      end

      def self.from_hash(hash)
        new hash[:type], hash[:value], hash[:duration], hash[:number]
      end

      def to_hash
        hash = { :type => @type, :value => @value, :duration => @duration }
        hash[:number] = @number if @number
        hash
      end

      def clone_with(hash)
        self.class.from_hash(to_hash.merge hash)
      end

      def scale_value(scaling_factor)
        clone_with :value => @value * scaling_factor.to_f
      end

      def scale_duration(scaling_factor)
        clone_with :duration => @duration * scaling_factor.to_f
      end

      # Duration of the Event in beats (e.g. 1.0 is a quarter note in 4/4 time signatures)
      # This is the absolute value of the duration attribute used to construct the object.
      # @see rest?
      def duration
        @abs_duration ||= @duration.abs
      end

      # By convention, any events with negative durations are considered a rest
      def rest?
        @duration < 0
      end

      def duration_in_pulses(pulses_per_beat)
        @duration_in_pulses ||= (duration * pulses_per_beat).round
      end

      def == other
        other.respond_to? :type and @type == other.type and
        other.respond_to? :number and @number == other.number and
        other.respond_to? :value and @value == other.value and
        other.respond_to? :duration and @duration == other.duration
      end

      def to_s
        "#@type" + (@number ? "[#@number]" : '') + ",#{sprintf '%.2f',@value},#{sprintf '%.2f',@duration}"
      end

      def inspect
        "#@type" + (@number ? "[#@number]" : '') + ",#@value,#@duration"
      end

    end

  end
end
