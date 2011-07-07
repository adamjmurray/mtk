module MTK

  # Defines values for standard dynamic symbols.
  #
  # These can be thought of like constants, but in order to distinguish 'f' (forte) from the {PitchClass} 'F'
  # it was necessary to use lower-case names and therefore define them as "pseudo constant" methods.
  # The methods are available either throught the module (MTK::Dynamics::f) or via mixin (include MTK::Dynamics;  f)
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

    # The values of all "psuedo constants" defined in this module
    DYNAMICS = [ppp, pp, p, mp, mf, f, ff, fff].freeze

    # The names of all "psuedo constants" defined in this module
    DYNAMIC_NAMES = %w[ppp pp p mp mf f ff fff].freeze

    # Lookup the value of an intensity constant by name.
    # This method supports appending '+' or '-' for more fine-grained values.
    # '+' and '-' add and subtract 1/24, respectively (enforcing the upper bound of 1.0 for 'fff+').
    # @example lookup value of 'mp+', which is 0.5416666666666666  (0.5 + 1/24.0)
    #         MTK::Intensities['mp+']
    def self.[](name)
      return 1.0 if name == "fff+" # special case because "fff" is already the maximum

      modifier = nil
      if name =~ /(\w+)([+-])/
        name = $1
        modifier = $2
      end

      value = send name
      value += 1.0/24 if modifier == '+'
      value -= 1.0/24 if modifier == '-'
      value
    rescue
      nil
    end

  end
end
