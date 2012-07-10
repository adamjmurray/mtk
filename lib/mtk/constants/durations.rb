require 'rational'

module MTK
  module Constants

    # Defines duration constants using abbreviations for standard rhythm values ('w' for whole note, 'h' for half note, etc).
    #
    # These can be thought of like constants, but in order to distinguish 'e' (eighth note) from the {PitchClass} 'E'
    # it was necessary to use lower-case names and therefore define them as "pseudo constant" methods.
    # The methods are available either through the module (MTK::Durations::e) or via mixin (include MTK::Durations; e)
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
      define_constant 'w', 4

      # half note
      define_constant 'h', 2

      # quarter note
      define_constant 'q', 1

      # eight note
      define_constant 'e', Rational(1,2)

      # sixteenth note
      define_constant 's', Rational(1,4)

      # thirty-second note
      define_constant 'r', Rational(1,8)

      # sixty-fourth note
      define_constant 'x', Rational(1,16)

      # The values of all "psuedo constants" defined in this module
      DURATIONS = [w, h, q, e, s, r, x].freeze

      # The names of all "psuedo constants" defined in this module
      DURATION_NAMES = %w[w h q e s r x].freeze

      # Lookup the value of an duration constant by name.
      # This method supports appending any combination of '.' and 't' for more fine-grained values.
      # each '.' multiplies by 3/2, and each 't' multiplies by 2/3.
      # @example lookup value of 'e.' (eight note), which is 0.75 (0.5 * 1.5)
      #         MTK::Durations['e.']
      def self.[](name)
        begin
          modifier = nil
          if name =~ /(\w)((.|t)*)/
            name = $1
            modifier = $2
          end

          value = send name
          modifier.each_char do |mod|
            case mod
              when '.' then value *= Rational(3,2)
              when 't' then value *= Rational(2,3)
            end
          end
          value

        rescue
          nil
        end
      end

    end
  end
end
