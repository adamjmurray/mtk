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
          pitch = nil
          intensity = nil
          duration = nil

          for pattern in @patterns
            element = pattern.next
            case
              when element.is_a?(Pitch) then pitch = element
              when element.is_a?(PitchSet) then pitch = element.to_a
              when pattern.type == :intensity then intensity = element
              when pattern.type == :duration then duration = element
            end
          end

          timeline[beat] = if pitch.is_a? Enumerable
            pitch.map{|p| Note(p,intensity,duration) }
          else
            Note(pitch,intensity,duration)
          end


          beat += @step_size
          step_count += 1
        end


        timeline
      end

    end

  end
end
