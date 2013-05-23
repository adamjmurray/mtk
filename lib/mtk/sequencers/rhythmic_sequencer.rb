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

  end
end
