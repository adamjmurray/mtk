module MTK
  module Sequencers

    # A Sequencer which uses a :rhythm type {Patterns::Pattern} to determine the delta times between entries in the {Timeline}.
    class RhythmicSequencer < Sequencer

      def initialize(patterns, options={})
        super
        @rhythm = options[:rhythm] or raise ArgumentError.new(":rhythm option is required")
      end

      def rewind
        super
        @rhythm.rewind if @rhythm
      end

     ########################
      protected

      # (see Sequencer#advance)
      def advance
        @time += @rhythm.next
      end

    end


    # Construct a {LegatoSequencer} from any supported type
    def RhythmicSequencer(*args)
      options  = (args[-1].is_a? Hash) ? args.pop : {}
      patterns = (args.length==1 and args[0].is_a? Array) ? args[0] : args
      RhythmicSequencer.new(patterns,options)
    end
    module_function :RhythmicSequencer

  end
end
