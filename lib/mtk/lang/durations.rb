module MTK
  module Lang

    # Defines duration constants using abbreviations for standard rhythm values ('w' for whole note, 'h' for half note, etc).
    #
    # These can be thought of like constants, but in order to support the lower case names,
    # it was necessary to define them as "pseudo constant" methods.
    # Like constants, these methods are available either through the module (MTK::Lang::Durations::q) or
    # via mixin (include MTK::Lang::Durations; q). They are listed under the "Instance Attribute Summary" of this page.
    #
    # These values assume the quarter note is one beat, so you may find they work best with 4/4 and other */4 time signatures
    # (although it's certainly possible to use them with less common time signatures like 5/8).
    #
    # @note Including this module defines a bunch of single-character variables, which may shadow existing variable names.
    #       Just be mindful of what is defined in this module when including it.
    #
    # @see Core::Duration
    # @see Events::Note
    module Durations
      extend MTK::Lang::PseudoConstants

      # @private
      # @!macro [attach] define_duration
      #   $3: $4 beat(s)
      #   @!attribute [r]
      #   @return [MTK::Core::Duration] duration of $4 beat(s)
      def self.define_duration name, value, description, beats
        define_constant name, value
      end
      

      define_duration 'w', MTK::Core::Duration[4], 'whole note', 4

      define_duration 'h', MTK::Core::Duration[2], 'half note', 2

      define_duration 'q', MTK::Core::Duration[1], 'quarter note', 1

      define_duration 'e', MTK::Core::Duration[Rational(1,2)], 'eighth note', '1/2'

      define_duration 's', MTK::Core::Duration[Rational(1,4)], 'sixteenth note', '1/4'

      define_duration 'r', MTK::Core::Duration[Rational(1,8)], 'thirty-second note', '1/8'

      define_duration 'x', MTK::Core::Duration[Rational(1,16)], 'sixty-fourth note', '1/16'


      # All "psuedo constants" defined in this module
      DURATIONS = [w, h, q, e, s, r, x].freeze

      # The names of all "psuedo constants" defined in this module
      # @see MTK::Core::Duration::NAMES
      DURATION_NAMES = MTK::Core::Duration::NAMES

    end
  end
end
