module MTK
  module Lang

    # Defines interval group constants to represent the interval patterns in relative chords and scales.
    #
    # @see Groups::IntervalGroup
    # @see Groups::RelativeChord
    # @see Lang::RelativeChords
    module IntervalGroups
      extend MTK::Lang::PseudoConstants

      # @private
      # @!macro [attach] define_interval_group
      #   Intervals of $2 semitones
      #
      #   $3
      #   @!attribute [r]
      #   @return [MTK::Core::IntervalGroup] interval group of $2 semitones
      def self.define_interval_group name, semitones_list, description=''
        intervals = semitones_list.map{|semitones| MTK::Core::Interval[semitones] }
        interval_group = MTK::Groups::IntervalGroup.new(intervals)
        define_constant name, interval_group
      end


      define_interval_group 'MAJOR_TRIAD', [0,4,7]

      define_interval_group 'MINOR_TRIAD', [0,3,7]

      define_interval_group 'DIMINISHED_TRIAD', [0,3,6]

      define_interval_group 'AUGMENTED_TRIAD', [0,4,8]



      define_interval_group 'ACOUSTIC_SCALE', [0, 2, 4, 6, 7, 9, 10]

      define_interval_group 'ADONAI_MALAKH_MODE', [0, 2, 4, 5, 7, 8, 10]

      define_interval_group 'ALTERED_SCALE', [0, 1, 3, 4, 6, 8, 10]

      define_interval_group 'ARABIAN_SCALE', [0, 2, 4, 5, 6, 8, 10], 'AKA major locrian scale'

      define_interval_group 'AUGMENTED_SCALE', [0, 3, 4, 7, 8, 11]

      define_interval_group 'BALINESE_SCALE', [0, 1, 3, 7, 8]

      define_interval_group 'BEBOP_DOMINANT_SCALE', [0, 2, 4, 5, 7, 9, 10, 11]

      define_interval_group 'BLUES_SCALE', [0, 3, 5, 6, 7, 10]

      define_interval_group 'BYZANTINE_SCALE', [0, 1, 4, 5, 7, 8, 11], 'AKA double harmonic scale'

      define_interval_group 'CHROMATIC_SCALE', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

      define_interval_group 'DORIAN_MODE', [0, 2, 3, 5, 7, 9, 10]

      define_interval_group 'EGYPTIAN_SCALE', [0, 2, 5, 7, 10]

      define_interval_group 'ENIGMATIC_SCALE', [0, 1, 4, 6, 8, 10, 11]

      define_interval_group 'GYPSY_SCALE', [0, 2, 3, 6, 7, 8, 10]

      define_interval_group 'HALF_DIMINISHED_SCALE', [0, 2, 3, 5, 6, 8, 10]

      define_interval_group 'HARMONIC_MAJOR_SCALE', [0, 2, 4, 5, 7, 8, 11]

      define_interval_group 'HARMONIC_MINOR_SCALE', [0, 2, 3, 5, 7, 8, 11]

      define_interval_group 'HIRAJOSHI_SCALE', [0, 4, 6, 7, 11]

      define_interval_group 'HUNGARIAN_MAJOR_SCALE', [0, 3, 4, 6, 7, 9, 10]

      define_interval_group 'HUNGARIAN_MINOR_SCALE', [0, 2, 3, 6, 7, 8, 11]

      define_interval_group 'IN_SCALE', [0, 1, 5, 7, 8]

      define_interval_group 'INSEN_SCALE', [0, 1, 5, 7, 10]

      define_interval_group 'IWATO_SCALE', [0, 1, 5, 6, 10]

      define_interval_group 'JAVANESE_SCALE', [0, 1, 3, 5, 7, 9, 10]

      define_interval_group 'LOCRIAN_MODE', [0, 1, 3, 5, 6, 8, 10]

      define_interval_group 'LYDIAN_AUGMENTED_SCALE', [0, 2, 4, 6, 8, 9, 11]

      define_interval_group 'LYDIAN_MODE', [0, 2, 4, 6, 7, 9, 11]

      define_interval_group 'MAJOR_SCALE', [0, 2, 4, 5, 7, 9, 11], 'AKA ionian mode'

      define_interval_group 'MAJOR_PENTATONIC_SCALE', [0, 2, 4, 7, 9]

      define_interval_group 'MELODIC_MINOR_SCALE', [0, 2, 3, 5, 7, 9, 11], 'the ascending form of the melodic minor scale (the descending form is identical to the harmonic minor scale)'

      define_interval_group 'MINOR_PENTATONIC_SCALE', [0, 3, 5, 7, 10]

      define_interval_group 'MIXOLYDIAN_MODE', [0, 2, 4, 5, 7, 9, 10]

      define_interval_group 'MINOR_SCALE', [0, 2, 3, 5, 7, 8, 10], 'the natural minor scale AKA aeolian mode'

      define_interval_group 'NEAPOLITAN_MAJOR_SCALE', [0, 1, 3, 5, 7, 9, 11]

      define_interval_group 'NEAPOLITAN_MINOR_SCALE', [0, 1, 3, 5, 7, 8, 11]

      define_interval_group 'OCTATONIC_SCALE', [0, 2, 3, 5, 6, 8, 9, 11], 'One of 2 forms of the octatonic scale. This one starts with a whole step. See OCTATONIC_ALT_SCALE'

      define_interval_group 'OCTATONIC_ALT_SCALE', [0, 1, 3, 4, 6, 7, 9, 10], 'One of 2 forms of the octatonic scale. This one starts with a half step. See OCTATONIC_SCALE'

      define_interval_group 'PELOG_SCALE', [0, 1, 3, 6, 7, 8, 10]

      define_interval_group 'PERSIAN_SCALE', [0, 1, 4, 5, 6, 8, 11]

      define_interval_group 'PHRYGIAN_MODE', [0, 1, 3, 5, 7, 8, 10]

      define_interval_group 'PROMETHEUS_SCALE', [0, 2, 4, 6, 9, 10]

      define_interval_group 'SCALE_OF_HARMONICS', [0, 3, 4, 5, 7, 9]

      define_interval_group 'SLENDRO_SCALE', [0, 2, 5, 7, 9]

      define_interval_group 'SPANISH_SCALE', [0, 1, 4, 5, 7, 8, 10], 'AKA phrygian dominant scale'

      define_interval_group 'TRITONE_SCALE', [0, 1, 4, 6, 7, 10]

      define_interval_group 'UKRAINIAN_DORIAN_SCALE', [0, 2, 3, 6, 7, 9, 10]

      define_interval_group 'WHOLE_TONE_SCALE', [0, 2, 4, 6, 8, 10]

      define_interval_group 'YO_SCALE', [0, 2, 5, 7, 10]


      # All triads (3 note chords) defined in this module
      TRIADS = [MAJOR_TRIAD, MINOR_TRIAD, DIMINISHED_TRIAD, AUGMENTED_TRIAD].freeze

      # All scales and modes defined in this module
      SCALES = [ACOUSTIC_SCALE, ADONAI_MALAKH_MODE, ALTERED_SCALE, ARABIAN_SCALE, AUGMENTED_SCALE, BALINESE_SCALE,
                BEBOP_DOMINANT_SCALE, BLUES_SCALE, BYZANTINE_SCALE, CHROMATIC_SCALE, DORIAN_MODE, EGYPTIAN_SCALE,
                ENIGMATIC_SCALE, GYPSY_SCALE, HALF_DIMINISHED_SCALE, HARMONIC_MAJOR_SCALE, HARMONIC_MINOR_SCALE,
                HIRAJOSHI_SCALE, HUNGARIAN_MAJOR_SCALE, HUNGARIAN_MINOR_SCALE, IN_SCALE, INSEN_SCALE, IWATO_SCALE,
                JAVANESE_SCALE, LOCRIAN_MODE, LYDIAN_AUGMENTED_SCALE, LYDIAN_MODE, MAJOR_SCALE, MAJOR_PENTATONIC_SCALE,
                MELODIC_MINOR_SCALE, MINOR_PENTATONIC_SCALE, MIXOLYDIAN_MODE, MINOR_SCALE, NEAPOLITAN_MAJOR_SCALE,
                NEAPOLITAN_MINOR_SCALE, OCTATONIC_SCALE, OCTATONIC_ALT_SCALE, PELOG_SCALE, PERSIAN_SCALE, PHRYGIAN_MODE,
                PROMETHEUS_SCALE, SCALE_OF_HARMONICS, SLENDRO_SCALE, SPANISH_SCALE, TRITONE_SCALE,
                UKRAINIAN_DORIAN_SCALE, WHOLE_TONE_SCALE, YO_SCALE]

      # Names of all scales and mode constants defined in this module
      SCALE_NAMES = %w[ACOUSTIC_SCALE ADONAI_MALAKH_MODE ALTERED_SCALE ARABIAN_SCALE AUGMENTED_SCALE BALINESE_SCALE
                BEBOP_DOMINANT_SCALE BLUES_SCALE BYZANTINE_SCALE CHROMATIC_SCALE DORIAN_MODE EGYPTIAN_SCALE
                ENIGMATIC_SCALE GYPSY_SCALE HALF_DIMINISHED_SCALE HARMONIC_MAJOR_SCALE HARMONIC_MINOR_SCALE
                HIRAJOSHI_SCALE HUNGARIAN_MAJOR_SCALE HUNGARIAN_MINOR_SCALE IN_SCALE INSEN_SCALE IWATO_SCALE
                JAVANESE_SCALE LOCRIAN_MODE LYDIAN_AUGMENTED_SCALE LYDIAN_MODE MAJOR_SCALE MAJOR_PENTATONIC_SCALE
                MELODIC_MINOR_SCALE MINOR_PENTATONIC_SCALE MIXOLYDIAN_MODE MINOR_SCALE NEAPOLITAN_MAJOR_SCALE
                NEAPOLITAN_MINOR_SCALE OCTATONIC_SCALE OCTATONIC_ALT_SCALE PELOG_SCALE PERSIAN_SCALE PHRYGIAN_MODE
                PROMETHEUS_SCALE SCALE_OF_HARMONICS SLENDRO_SCALE SPANISH_SCALE TRITONE_SCALE
                UKRAINIAN_DORIAN_SCALE WHOLE_TONE_SCALE YO_SCALE]

      # All constants defined in this module
      INTERVAL_GROUPS = (TRIADS + SCALES).freeze


      def find_scale(name)
        name = name.to_s.upcase.gsub(' ', '_')
        unless SCALE_NAMES.include? name
          scale_name = "#{name}_SCALE"
          if SCALE_NAMES.include? scale_name
            name = scale_name
          else
            mode_name = "#{name}_MODE"
            if SCALE_NAMES.include? mode_name
              name = mode_name
            else
              return nil
            end
          end
        end
        const_get name
      end
      module_function :find_scale

    end

  end
end
