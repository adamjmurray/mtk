require 'rational'

module MTK
  module Lang

    # Defines duration constants using abbreviations for standard rhythm values ('w' for whole note, 'h' for half note, etc).
    #
    # These can be thought of like constants, but they
    # use lower-case names and therefore define them as "pseudo constant" methods.
    # The methods are available either through the module (MTK::Lang::Durations::e) or via mixin (include MTK::Lang::Durations; q)
    #
    # These values assume the quarter note is one beat (1.0), so they work best with 4/4 and other */4 time signatures.
    #
    # @note Including this module defines a bunch of single-character variables, which may shadow existing variable names.
    #       Just be mindful of what is defined in this module when including it.
    #
    # @see Core::Duration
    # @see Events::Note
    module Durations
      extend MTK::Lang::PseudoConstants

      # whole note
      # @macro [attach] durations.define_constant
      #   @attribute [r]
      #   @return [$2] duration for $1
      define_constant 'w', MTK::Core::Duration[4]

      # half note
      define_constant 'h', MTK::Core::Duration[2]

      # quarter note
      define_constant 'q', MTK::Core::Duration[1]

      # eight note
      define_constant 'e', MTK::Core::Duration[Rational(1,2)]

      # sixteenth note
      define_constant 's', MTK::Core::Duration[Rational(1,4)]

      # thirty-second note
      define_constant 'r', MTK::Core::Duration[Rational(1,8)]

      # sixty-fourth note
      define_constant 'x', MTK::Core::Duration[Rational(1,16)]

      # The values of all "psuedo constants" defined in this module
      DURATIONS = [w, h, q, e, s, r, x].freeze

      # The names of all "psuedo constants" defined in this module
      # @see MTK::Core::Duration::NAMES
      DURATION_NAMES = MTK::Core::Duration::NAMES

    end
  end
end
