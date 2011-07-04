module MTK
  module Sequencer

    class RhythmicSequencer

      attr_accessor :max_times

      def initialize(patterns, options={})
        @patterns = patterns.clone
        @patterns.each_with_index do |pattern, index|
          if pattern.type == :rhythm
            @rhythm = pattern
            @patterns.delete_at index # so we don't enumerate the rhythm values in EventBuilder
          end
        end

        # TODO: consider supporting max_time (for largest time allowed) and rename this to something else,
        # like max_iterations?
        @max_times = options[:max_times]
        @event_builder = EventBuilder.new(options)
      end

      def to_timeline
        timeline = Timeline.new
        beat = 0
        count = 0

        loop do
          break if @max_times and count >= @max_times

          events = @event_builder.next_events @patterns
          beat += @rhythm.next

          timeline[beat] = events if events

          count += 1
        end

        timeline
      end

    end

  end
end
