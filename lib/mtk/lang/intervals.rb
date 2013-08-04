module MTK
  module Lang

    # Defines a constant for {Core::Interval}s up to an octave using diatonic naming conventions
    #
    # Naming conventions
    #   P#: perfect interval
    #   M#: major interval
    #   m#: minor interval
    #   TT: tritone
    #   a#: augmented interval
    #   d#: diminished interval
    #
    # These can be thought of like constants, but in order to support things like 'm2' (minor) as well as 'M2' (major),
    # it was necessary to use lower-case names for some of the values and therefore define them as "pseudo constant" methods.
    # Like constants, these methods are available either through the module (MTK::Lang::Intervals::m2) or
    # via mixin (include MTK::Lang::Intervals; m2). They are listed under the "Instance Attribute Summary" of this page.
    #
    # @see Core::Interval
    # @see http://en.wikipedia.org/wiki/Interval_(music)#Main_intervals
    module Intervals
      extend MTK::Lang::PseudoConstants

      # @private
      # @!macro [attach] define_interval
      #   $3 ($4 semitones)
      #   @!attribute [r]
      #   @return [MTK::Core::Interval] interval of $4 semitones
      def self.define_interval name, value, description, semitones
        define_constant name, value
      end


      # @see #d2
      define_interval 'P1', MTK::Core::Interval[0], 'perfect unison', 0

      # @see #P1
      define_interval 'd2', MTK::Core::Interval[0], 'diminished second', 0


      # @see #a1
      define_interval 'm2', MTK::Core::Interval[1], 'minor second', 1

      # @see #m2
      define_interval 'a1', MTK::Core::Interval[1], 'augmented unison', 1


      # @see #d3
      define_interval 'M2', MTK::Core::Interval[2], 'major second', 2

      # @see #M2
      define_interval 'd3', MTK::Core::Interval[2], 'diminished third', 2


      # @see #a2
      define_interval 'm3', MTK::Core::Interval[3], 'minor third', 3

      # @see #m3
      define_interval 'a2', MTK::Core::Interval[3], 'augmented second', 3


      # @see #d4
      define_interval 'M3', MTK::Core::Interval[4], 'major third', 4

      # @see #M3
      define_interval 'd4', MTK::Core::Interval[4], 'diminished fourth', 4


      # @see #a3
      define_interval 'P4', MTK::Core::Interval[5], 'perfect fourth', 5

      # @see #P4
      define_interval 'a3', MTK::Core::Interval[5], 'augmented third', 5


      # @see #a4
      # @see #d5
      define_interval 'TT', MTK::Core::Interval[6], 'tritone', 6

      # @see #TT
      # @see #d5
      define_interval 'a4', MTK::Core::Interval[6], 'augmented fourth', 6

      # @see #TT
      # @see #a4
      define_interval 'd5', MTK::Core::Interval[6], 'diminished fifth', 6


      # @see #d6
      define_interval 'P5', MTK::Core::Interval[7], 'perfect fifth', 7

      # @see #P5
      define_interval 'd6', MTK::Core::Interval[7], 'diminished sixth', 7


      # @see #a5
      define_interval 'm6', MTK::Core::Interval[8], 'minor sixth', 8

      # @see #m6
      define_interval 'a5', MTK::Core::Interval[8], 'augmented fifth', 8


      # @see #d7
      define_interval 'M6', MTK::Core::Interval[9], 'major sixth', 9

      # @see #M6
      define_interval 'd7', MTK::Core::Interval[9], 'diminished seventh', 9


      # @see #a6
      define_interval 'm7', MTK::Core::Interval[10], 'minor seventh', 10

      # @see #m7
      define_interval 'a6', MTK::Core::Interval[10], 'augmented sixth', 10


      # @see #d8
      define_interval 'M7', MTK::Core::Interval[11], 'major seventh', 11

      # @see #M7
      define_interval 'd8', MTK::Core::Interval[11], 'diminished octave', 11


      # @see #a7
      define_interval 'P8', MTK::Core::Interval[12], 'perfect octave', 12

      # @see #P8
      define_interval 'a7', MTK::Core::Interval[12], 'augmented seventh', 12


      # The values of all "psuedo constants" defined in this module
      INTERVALS = [P1, d2, m2, a1, M2, d3, m3, a2, M3, d4, P4, a3, TT, a4, d5, P5, d6, m6, a5, M6, d7, m7, a6, M7, d8, P8, a7].freeze

      # The names of all "psuedo constants" defined in this module
      # @see MTK::Core::Interval::NAMES_BY_VALUE
      INTERVAL_NAMES = MTK::Core::Interval::ALL_NAMES

    end
  end
end
