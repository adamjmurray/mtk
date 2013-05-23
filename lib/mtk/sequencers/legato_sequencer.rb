module MTK
  module Sequencers

    # A Sequencer which uses the longest duration of the events at each step to determine
    # the delta times between entries in the {Timeline}.
    class LegatoSequencer < Sequencer

      # (see Sequencer#next)
      def next
        @previous_events = super
      end

     ########################
      protected

      # (see Sequencer#advance)
      def advance
        @time += @previous_events.map{|event| event.length }.max
      end

    end

  end
end
