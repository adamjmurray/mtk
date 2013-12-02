require 'rational'

module MTK
  module Lang

    # Defines interval group constants to represent relative chords
    #
    # @see Groups::IntervalGroup
    # @see Groups::RelativeChord
    # @see Lang::RelativeChords
    module IntervalGroups
      extend MTK::Lang::PseudoConstants

      # @private
      # @!macro [attach] define_interval_group
      #   $3: intervals of $2 semitones
      #   @!attribute [r]
      #   @return [MTK::Core::IntervalGroup] interval group of $2 semitones
      def self.define_interval_group name, semitones_list, description
        intervals = semitones_list.map{|semitones| MTK::Core::Interval[semitones] }
        interval_group = MTK::Groups::IntervalGroup.new(intervals)
        define_constant name, interval_group
      end


      define_interval_group 'MAJOR_TRIAD', [0,4,7], 'major triad'

      define_interval_group 'MINOR_TRIAD', [0,3,7], 'minor triad'

      define_interval_group 'DIMINISHED_TRIAD', [0,3,6], 'diminished triad'

      define_interval_group 'AUGMENTED_TRIAD', [0,4,8], 'augmented triad'


      # All onstants"defined in this module
      INTERVAL_GROUPS = [MAJOR_TRIAD, MINOR_TRIAD, DIMINISHED_TRIAD, AUGMENTED_TRIAD].freeze

    end

  end
end
