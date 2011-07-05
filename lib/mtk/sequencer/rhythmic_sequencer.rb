module MTK
  module Sequencer

    # A Sequencer which uses a :rhythm type {Pattern} to determine the delta times between entries in the {Timeline}.
    class RhythmicSequencer < AbstractSequencer

      def initialize(patterns, options={})
        patterns = patterns.clone
        patterns.each_with_index do |pattern, index|
          if pattern.type == :rhythm
            @rhythm = pattern
            patterns.delete_at index # so we don't enumerate the rhythm values in EventBuilder
          end
        end
        super(patterns, options)
      end

     ########################
      protected

      # (see AbstractSequencer#advance)
      def advance time
        time + @rhythm.next
      end

    end

  end
end
