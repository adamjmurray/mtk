module MTK

  # Defines values for standard dynamic symbols.
  #
  # These can be thought of like constants, but in order to distinguish 'f' (forte) from the {PitchClass} 'F'
  # it was necessary to use lower-case names and therefore define them as "pseudo constant" methods.
  # The methods are available either throught the module (MTK::Dynamics::f) or via mixin (include MTK::Dynamics;  f)
  #
  # These values are intensities in the range 0.0 - 1.0, so they can be easily scaled (unlike MIDI velocities).
  #
  # @note Including this module shadows Ruby's built-in p() method. 
  #   If you include this module, you can access the built-in p() method via Kernel.p()
  #
  # @see Note
  module Dynamics
    extend MTK::PseudoConstants
    
    # NOTE: the yard doc macros here only fill in [$2] with the actual value when generating docs under Ruby 1.9+
    
    # pianississimo 
    # @macro [attach] dynamics.define_constant
    #   @attribute [r]
    #   @return [$2] intensity value for $1   
    define_constant 'ppp', 0.125

    # pianissimo      
    define_constant 'pp', 0.25

    # piano
    # @note Including this module shadows Ruby's built-in p() method. 
    #   If you include this module, you can access the built-in p() method via Kernel.p()
    define_constant 'p', 0.375

    # mezzo-piano
    define_constant 'mp', 0.5

    # mezzo-forte
    define_constant 'mf', 0.625

    # forte
    define_constant 'f', 0.75
    
    # fortissimo
    define_constant 'ff', 0.875

    # fortississimo
    define_constant 'fff', 1.0

    def self.[](name)
      send name
    rescue
      nil
    end

    DYNAMICS = [ppp, pp, p, mp, mf, f, ff, fff].freeze

  end
end
