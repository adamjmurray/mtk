module MTK
  module Sequencer

    # A Sequencer which has a constant {#step_size} time between {Timeline} entries.
    class StepSequencer < AbstractSequencer

      # The time between entries in the {Timeline}.
      attr_accessor :step_size

      def initialize(patterns, options={})
        super
        @step_size = options.fetch :step_size, 1
      end

     ########################
      protected

      # (see AbstractSequencer#advance)
      def advance time
        time + @step_size
      end

    end

  end
end
