module MTK
  module Lang

    # Defines intensity constants using standard dynamic symbols.
    #
    # These can be thought of like constants, but they
    # use lower-case names and therefore define them as "pseudo constant" methods.
    # The methods are available either through the module (MTK::Core::Intensities::ff) or via mixin (include MTK::Core::Intensities; ff)
    #
    # These values are intensities in the range 0.125 - 1.0 (in increments of 1/8), so they can be easily scaled (unlike MIDI velocities).
    #
    # @note Including this module shadows Ruby's built-in p() method.
    #   If you include this module, you can access the built-in p() method via Kernel.p()
    #
    # @see Events::Note
    module Intensities
      extend MTK::Lang::PseudoConstants

      # pianississimo
      # @macro [attach] intensities.define_constant
      #   @attribute [r]
      #   @return [$2] intensity value for $1
      define_constant 'ppp', MTK::Core::Intensity[0.125]

      # pianissimo
      define_constant 'pp', MTK::Core::Intensity[0.25]

      # piano
      # @note Including this module shadows Ruby's built-in p() method.
      #   If you include this module, you can access the built-in p() method via Kernel.p()
      define_constant 'p', MTK::Core::Intensity[0.375]

      # mezzo-piano
      define_constant 'mp', MTK::Core::Intensity[0.5]

      # mezzo-forte
      define_constant 'mf', MTK::Core::Intensity[0.625]

      # forte
      define_constant 'f', MTK::Core::Intensity[0.75]

      # fortissimo
      define_constant 'ff', MTK::Core::Intensity[0.875]

      # fortississimo
      define_constant 'fff', MTK::Core::Intensity[1.0]

      # The values of all "psuedo constants" defined in this module
      INTENSITIES = [ppp, pp, p, mp, mf, f, ff, fff].freeze

      # The names of all "psuedo constants" defined in this module
      INTENSITY_NAMES = MTK::Core::Intensity::NAMES

    end
  end
end
