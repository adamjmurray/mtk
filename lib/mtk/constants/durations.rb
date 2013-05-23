require 'rational'

module MTK
  module Constants

    # Defines duration constants using abbreviations for standard rhythm values ('w' for whole note, 'h' for half note, etc).
    #
    # In order to avoid conflict with pitch class 'e', the constant for eighth note is 'i'
    #
    # These can be thought of like constants, but they
    # use lower-case names and therefore define them as "pseudo constant" methods.
    # The methods are available either through the module (MTK::Durations::e) or via mixin (include MTK::Durations; q)
    #
    # These values assume the quarter note is one beat (1.0), so they work best with 4/4 and other */4 time signatures.
    #
    # @note Including this module defines a bunch of single-character variables, which may shadow existing variable names.
    #       Just be mindful of what is defined in this module when including it.
    #
    # @see Note
    module Durations
      extend Helpers::PseudoConstants

      # NOTE: the yard doc macros here only fill in [$2] with the actual value when generating docs under Ruby 1.9+

      # whole note
      # @macro [attach] durations.define_constant
      #   @attribute [r]
      #   @return [$2] number of beats for $1
      define_constant 'w', MTK::Duration[4]

      # half note
      define_constant 'h', MTK::Duration[2]

      # quarter note
      define_constant 'q', MTK::Duration[1]

      # eight note
      define_constant 'i', MTK::Duration[Rational(1,2)]

      # sixteenth note
      define_constant 's', MTK::Duration[Rational(1,4)]

      # thirty-second note
      define_constant 'r', MTK::Duration[Rational(1,8)]

      # sixty-fourth note
      define_constant 'x', MTK::Duration[Rational(1,16)]

      # The values of all "psuedo constants" defined in this module
      DURATIONS = [w, h, q, i, s, r, x].freeze

      # The names of all "psuedo constants" defined in this module
      DURATION_NAMES = MTK::Duration::NAMES

    end
  end
end
