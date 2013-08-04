module MTK
  module Lang

    # Defines intensity constants using standard dynamic symbols.
    #
    # These can be thought of like constants, but in order to support the lower case names,
    # it was necessary to define them as "pseudo constant" methods.
    # Like constants, these methods are available either through the module (MTK::Lang::Intensities::f) or
    # via mixin (include MTK::Lang::Intensities; f). They are listed under the "Instance Attribute Summary" of this page.
    #
    # These values are intensities in the range 0.125 - 1.0 (in increments of 1/8), so they can be easily scaled (unlike MIDI velocities).
    #
    # @note Including this module shadows Ruby's built-in p() method.
    #       If you include this module, you can access the built-in p() method via Kernel.p()
    #       Also be aware you might shadow existing variable names, like f.
    #
    # @see Core::Intensity
    # @see Events::Note
    module Intensities
      extend MTK::Lang::PseudoConstants

      # @private
      # @!macro [attach] define_intensity
      #   $3: $4% intensity
      #   @!attribute [r]
      #   @return [MTK::Core::Interval] intensity of $4%
      def self.define_intensity name, value, description, percentage_intensity
        define_constant name, value
      end


      define_intensity 'ppp', MTK::Core::Intensity[0.125], 'pianississimo', '12.5'

      define_intensity 'pp', MTK::Core::Intensity[0.25], 'pianissimo', 25

      # @note Including this module shadows Ruby's built-in p() method.
      #   If you include this module, you can access the built-in p() method via Kernel.p()
      define_intensity 'p', MTK::Core::Intensity[0.375], 'piano', '37.5'

      define_intensity 'mp', MTK::Core::Intensity[0.5], 'mezzo-piano', 50

      define_intensity 'mf', MTK::Core::Intensity[0.625], 'mezzo-forte', '62.5'

      define_intensity 'f', MTK::Core::Intensity[0.75], 'forte', 75

      define_intensity 'ff', MTK::Core::Intensity[0.875], 'fortissimo', '87.5'

      define_intensity 'fff', MTK::Core::Intensity[1.0], 'fortississimo', 100


      # All "psuedo constants" defined in this module
      INTENSITIES = [ppp, pp, p, mp, mf, f, ff, fff].freeze

      # The names of all "psuedo constants" defined in this module
      # @see MTK::Core::Intensity::NAMES
      INTENSITY_NAMES = MTK::Core::Intensity::NAMES

    end
  end
end
