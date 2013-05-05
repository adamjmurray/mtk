module MTK
  module Sequencers

    # A Sequencer which uses a :rhythm type {Patterns::Pattern} to determine the delta times between entries in the {Timeline}.
    class RhythmicSequencer < Sequencer

      def initialize(patterns, options={})
        patterns = patterns.clone
        patterns.each_with_index do |pattern, index|
          if pattern.type == :rhythm
            @rhythm = pattern
            patterns.delete_at index # so we don't enumerate the rhythm values in the EventChain
          end
        end
        super(patterns, options)
      end

      def rewind
        super
        @rhythm.rewind if @rhythm
      end

     ########################
      protected

      # (see Sequencer#advance!)
      def advance!
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
