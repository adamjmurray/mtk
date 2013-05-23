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
        @time += @previous_events.map{|event| event.duration }.max
      end

    end


    # Construct a {LegatoSequencer} from any supported type
    def LegatoSequencer(*args)
      options  = (args[-1].is_a? Hash) ? args.pop : {}
      patterns = (args.length==1 and args[0].is_a? Array) ? args[0] : args
      LegatoSequencer.new(patterns,options)
    end
    module_function :LegatoSequencer

  end
end
