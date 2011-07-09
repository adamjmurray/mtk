module MTK
  module Sequencer

    # A Sequencer which uses the longest duration of the events at each step to determine
    # the delta times between entries in the {Timeline}.
    class LegatoSequencer < AbstractSequencer

      # (see AbstractSequencer#next)
      def next
        @previous_events = super
      end

     ########################
      protected

      # (see AbstractSequencer#advance!)
      def advance!
        @time += @previous_events.map{|event| event.duration }.max
      end

    end

  end
end
