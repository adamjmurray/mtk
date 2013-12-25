module MTK

  module Events

    # An interval of silence.
    #
    # By convention, MTK uses {Core::Duration}s with negative values for rests. This class forces the {#duration}
    # to always have a negative value.
    #
    # @note Because a negative durations indicate rests, other {Event} classes may represent rests too.
    #       Therefore, you should always determine if an {Event} is a rest via the {#rest?} method, instead
    #       of seeing if the class is an MTK::Events::Rest
    class Rest < Event

      def initialize(duration, channel=nil)
        super :rest, duration:duration, channel:channel
        self.duration = @duration # force to be a rest
      end

      def self.from_h(hash)
        new(hash[:duration], hash[:channel])
      end

      # Assign the duration, forcing to a negative value to indicate this is a rest.
      def duration= duration
        super
        @duration = -@duration unless @duration.rest? # force to be a rest
      end

      # Rests don't have a corresponding value in MIDI, so this is nil
      # @return nil
      def midi_value
        nil
      end

      # Rests don't have a corresponding value in MIDI, so this is a no-op
      def midi_value= value
      end

      def to_s
        "Rest(#{@duration})"
      end

      def inspect
        "#<Rest: @duration=#{@duration.value}" +
            if @channel then ", @channel=#{@channel}>" else '>' end
      end

    end
  end


  # Construct a {Events::Rest} from a list of any supported type for the arguments: pitch, intensity, duration, channel
  def Rest(*anything)
    anything = anything.first if anything.size == 1
    case anything
      when MTK::Events::Rest then anything
      when MTK::Events::Event then MTK::Events::Rest.new(anything.duration, anything.channel)
      when Numeric then MTK::Events::Rest.new(anything)
      when Duration then MTK::Events::Rest.new(anything)

      when Array
        duration = nil
        channel = nil
        unknowns = []
        anything.each do |item|
          case item
            when MTK::Core::Duration then duration = item
            else unknowns << item
          end
        end

        duration  = MTK.Duration(unknowns.shift)  if duration.nil?  and not unknowns.empty?
        raise "MTK::Rest() couldn't find a duration in arguments: #{anything.inspect}" if duration.nil?
        channel = unknowns.shift.to_i if channel.nil? and not unknowns.empty?

        MTK::Events::Rest.new(duration, channel)

      else
        raise "MTK::Rest() doesn't understand #{anything.class}"
    end
  end
  module_function :Rest

end
