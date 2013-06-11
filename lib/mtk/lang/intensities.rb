module MTK
  module Lang

    # Defines intensity constants using standard dynamic symbols.
    #
    # These can be thought of like constants, but in order to distinguish 'f' (forte) from the {PitchClass} 'F'
    # it was necessary to use lower-case names and therefore define them as "pseudo constant" methods.
    # The methods are available either through the module (MTK::Intensities::f) or via mixin (include MTK::Intensities;  f)
    #
    # These values are intensities in the range 0.125 - 1.0 (in increments of 1/8), so they can be easily scaled (unlike MIDI velocities).
    #
    # It is also possible to retrieve values in increments of 1/24 by using the '+' and '-' suffix when looking
    # up values via the {.[]} method.
    #
    # @note Including this module shadows Ruby's built-in p() method.
    #   If you include this module, you can access the built-in p() method via Kernel.p()
    #
    # @see Note
    module Intensities
      extend MTK::Lang::PseudoConstants

      # NOTE: the yard doc macros here only fill in [$2] with the actual value when generating docs under Ruby 1.9+

      # pianississimo
      # @macro [attach] intensities.define_constant
      #   @attribute [r]
      #   @return [$2] intensity value for $1
      define_constant 'ppp', MTK::Intensity[0.125]

      # pianissimo
      define_constant 'pp', MTK::Intensity[0.25]

      # piano
      # @note Including this module shadows Ruby's built-in p() method.
      #   If you include this module, you can access the built-in p() method via Kernel.p()
      define_constant 'p', MTK::Intensity[0.375]

      # mezzo-piano
      define_constant 'mp', MTK::Intensity[0.5]

      # mezzo-forte
      define_constant 'mf', MTK::Intensity[0.625]

      # forte
      define_constant 'o', MTK::Intensity[0.75]

      # fortissimo
      define_constant 'ff', MTK::Intensity[0.875]

      # fortississimo
      define_constant 'fff', MTK::Intensity[1.0]

      # The values of all "psuedo constants" defined in this module
      INTENSITIES = [ppp, pp, p, mp, mf, o, ff, fff].freeze

      # The names of all "psuedo constants" defined in this module
      INTENSITY_NAMES = MTK::Intensity::NAMES

    end
  end
end
