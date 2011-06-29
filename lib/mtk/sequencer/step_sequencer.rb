module MTK
  module Sequencer

    class StepSequencer

      attr_accessor :step_size

      attr_reader :max_steps

      def initialize(patterns, options={})
        @patterns = patterns
        @step_size = options.fetch :step_size, 1
        @max_steps = options[:max_steps]
      end

      def to_timeline
        timeline = Timeline.new
        beat = 0
        step_count = 0

        loop do
          break if @max_steps and step_count >= @max_steps

          elements = @patterns.map{|pattern| pattern.next }
          notes = EventBuilder.events_for elements
          timeline[beat] = notes if notes

          beat += @step_size
          step_count += 1
        end

        timeline
      end

    end

  end
end
