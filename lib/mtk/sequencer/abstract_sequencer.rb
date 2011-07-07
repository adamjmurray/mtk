module MTK
  module Sequencer

    # A Sequencer produces {Timeline}s from a collection of {Pattern}s.
    #
    # @abstract Subclass and override {#advance} to implement a Sequencer.
    #
    class AbstractSequencer

      # The maximum number of [time,event_list] entries that will be generated for the {Timeline}.
      # nil means no maximum (be careful of infinite loops!)
      attr_accessor :max_steps

      # The maximum time (key) that will be generated for the {Timeline}.
      # nil means no maximum (be careful of infinite loops!)
      attr_accessor :max_time

      # Used by {#to_timeline} to builds event lists from the results of #{Pattern::Enumerator#next} for the {Pattern}s in this Sequencer.
      attr_reader :event_builder


      def initialize(patterns, options={})
        @patterns = patterns
        @max_steps = options[:max_steps]
        @max_time = options[:max_time]

        event_builder_class = options.fetch :event_builder_class, Helper::EventBuilder
        @event_builder = event_builder_class.new(patterns, options)
      end


      # Produce a {Timeline} from the {Pattern}s in this Sequencer.
      def to_timeline
        timeline = Timeline.new
        time = 0
        step = -1

        loop do
          step += 1
          break if @max_steps and step >= @max_steps

          events = @event_builder.next_events
          timeline[time] = events if events

          time = advance time
          break if @max_time and time > @max_time
        end

        timeline
      end


      ########################
      protected

      # Advance to the next time for the {Timeline} being produced by {#to_timeline}
      # @param time [Numeric] the current time
      # @return [Numeric] the next time
      def advance time
        time + 1 # default behavior simply advances one beat at a time
      end
      
    end

  end
end
