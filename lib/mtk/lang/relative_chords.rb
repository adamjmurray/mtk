module MTK
  module Lang

    # Defines relative chord constants using (roman numeral notation)[http://en.wikipedia.org/wiki/Roman_numeral_analysis]
    #
    # These can be thought of like constants, but in order to support the lower case names,
    # it was necessary to define them as "pseudo constant" methods.
    # Like constants, these methods are available either through the module (MTK::Lang::RelativeChords::i) or
    # via mixin (include MTK::Lang::RelativeChords; i). They are listed under the "Instance Attribute Summary" of this page.
    #
    # Standard roman numeral notation goes from I to VII because it assumes the scale has 7 notes.
    # MTK allows for modern scales containing more notes and provides constants for VIII and IX as well.
    #
    # @note Including this module defines a bunch of single-character variables, which may shadow existing variable names.
    #       Just be mindful of what is defined in this module when including it.
    #
    # @see Groups::RelativeChord
    #
    module RelativeChords
      extend MTK::Lang::PseudoConstants

      # @private
      # @!macro [attach] define_relative_chord
      #   $4: $3 at scale index $2
      #   @!attribute [r]
      #   @return [MTK::Groups::RelativeChord] $4
      def self.define_relative_chord name, scale_index, interval_group, description
        define_constant name, MTK::Groups::RelativeChord.new(scale_index, interval_group)
      end

      define_relative_chord 'I',   0, IntervalGroups::MAJOR_TRIAD, 'tonic major triad'

      define_relative_chord 'i',   0, IntervalGroups::MINOR_TRIAD, 'tonic minor triad'

      define_relative_chord 'II',  1, IntervalGroups::MAJOR_TRIAD, 'supertonic major triad'

      define_relative_chord 'ii',  1, IntervalGroups::MINOR_TRIAD, 'supertonic minor triad'

      define_relative_chord 'III', 2, IntervalGroups::MAJOR_TRIAD, 'mediant major triad'

      define_relative_chord 'iii', 2, IntervalGroups::MINOR_TRIAD, 'mediant minor triad'

      define_relative_chord 'IV',  3, IntervalGroups::MAJOR_TRIAD, 'subdominant major triad'

      define_relative_chord 'iv',  3, IntervalGroups::MINOR_TRIAD, 'subdominant minor triad'

      define_relative_chord 'V',   4, IntervalGroups::MAJOR_TRIAD, 'dominant major triad'

      define_relative_chord 'v',   4, IntervalGroups::MINOR_TRIAD, 'dominant minor triad'

      define_relative_chord 'VI',  5, IntervalGroups::MAJOR_TRIAD, 'submediant major triad'

      define_relative_chord 'vi',  5, IntervalGroups::MINOR_TRIAD, 'submediant minor triad'

      define_relative_chord 'VII', 6, IntervalGroups::MAJOR_TRIAD, 'subtonic major triad'

      define_relative_chord 'vii', 6, IntervalGroups::MINOR_TRIAD, 'subtonic minor triad'

      define_relative_chord 'VIII',7, IntervalGroups::MAJOR_TRIAD, '8th scale degree major triad'

      define_relative_chord 'viii',7, IntervalGroups::MINOR_TRIAD, '8th scale degree minor triad'

      define_relative_chord 'IX',  8, IntervalGroups::MAJOR_TRIAD, '9th scale degree major triad'

      define_relative_chord 'ix',  8, IntervalGroups::MINOR_TRIAD, '9th scale degree minor triad'

      # All "psuedo constants" defined in this module
      RELATIVE_CHORDS = [I, i, II, ii, III, iii, IV, iv, V, v, VI, vi, VII, vii, VIII, viii, IX, ix].freeze

      # The names of all "psuedo constants" defined in this module
      # @see MTK::Groups::RelativeChord::NAMES
      RELATIVE_CHORD_NAMES = MTK::Groups::RelativeChord::NAMES

    end
  end
end