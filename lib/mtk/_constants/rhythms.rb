module MTK

  # Rhythm values for meters where the quarter note gets the beat
  module Rhythms
    extend MTK::PseudoConstants

    # NOTE: the yard doc macros here only fill in [$2] with the actual value when generating docs under Ruby 1.9+

    # whole note
    # @macro [attach] dynamics.define_constant
    #   @attribute [r]
    #   @return [$2] number of beats for $1
    define_constant 'w', 4

    # half note
    define_constant 'h', 2

    # quarter note
    define_constant 'q', 1

    # eight note
    define_constant 'e', 0.5

    # sixteenth note
    define_constant 's', 0.25

    # thirty-second note
    define_constant 'r', 0.125

    # sixty-fourth note
    define_constant 'x', 0.0625

    def self.[](name)
      send name
    rescue
      begin
        const_get name
      rescue
        nil
      end
    end

    RHYTHMS = [w, h, q, e, s, r, x].freeze

  end
end
