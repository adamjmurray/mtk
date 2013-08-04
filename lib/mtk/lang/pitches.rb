module MTK
  module Lang

    # Defines a constants for each {Core::Pitch} in the standard MIDI range using scientific pitch notation.
    # The constants range from C-1 (MIDI value 0) to G9 (MIDI value)
    #
    # Because the character '#' cannot be used in the name of a constant,
    # the "black key" pitches are all named as flats with 'b' (for example, Gb3 or Db4).
    # And because the character '-' (minus) cannot be used in the name of a constant,
    # the low pitches use '_' (underscore) in place of '-' (minus) (for example C_1).
    #
    # To help automate the documentation, the constants are listed under "Instance Attribute Summary" on this page.
    #
    # @see Core::Pitch
    # @see Events::Note
    # @see http://en.wikipedia.org/wiki/Scientific_pitch_notation
  module Pitches

      # @private
      # @!macro [attach] define_pitch
      #   Pitch $1 (MIDI pitch $2)
      #   @!attribute [r]
      #   @return [MTK::Core::Pitch] Pitch $1 (value $2)
      def self.define_pitch name, value
        pitch = MTK::Core::Pitch.from_i(value)
        const_set name, pitch
        PITCHES << pitch
        PITCH_NAMES << name
      end

      # The values of all constants defined in this module
      # @note This is populated dynamically so the documentation does not reflect the actual value
      PITCHES = []

      # The names of all constants defined in this module
      # @note This is populated dynamically so the documentation does not reflect the actual value
      PITCH_NAMES = []

      define_pitch 'C_1', 0
      define_pitch 'Db_1', 1
      define_pitch 'D_1', 2
      define_pitch 'Eb_1', 3
      define_pitch 'E_1', 4
      define_pitch 'F_1', 5
      define_pitch 'Gb_1', 6
      define_pitch 'G_1', 7
      define_pitch 'Ab_1', 8
      define_pitch 'A_1', 9
      define_pitch 'Bb_1', 10
      define_pitch 'B_1', 11
      define_pitch 'C0', 12
      define_pitch 'Db0', 13
      define_pitch 'D0', 14
      define_pitch 'Eb0', 15
      define_pitch 'E0', 16
      define_pitch 'F0', 17
      define_pitch 'Gb0', 18
      define_pitch 'G0', 19
      define_pitch 'Ab0', 20
      define_pitch 'A0', 21
      define_pitch 'Bb0', 22
      define_pitch 'B0', 23
      define_pitch 'C1', 24
      define_pitch 'Db1', 25
      define_pitch 'D1', 26
      define_pitch 'Eb1', 27
      define_pitch 'E1', 28
      define_pitch 'F1', 29
      define_pitch 'Gb1', 30
      define_pitch 'G1', 31
      define_pitch 'Ab1', 32
      define_pitch 'A1', 33
      define_pitch 'Bb1', 34
      define_pitch 'B1', 35
      define_pitch 'C2', 36
      define_pitch 'Db2', 37
      define_pitch 'D2', 38
      define_pitch 'Eb2', 39
      define_pitch 'E2', 40
      define_pitch 'F2', 41
      define_pitch 'Gb2', 42
      define_pitch 'G2', 43
      define_pitch 'Ab2', 44
      define_pitch 'A2', 45
      define_pitch 'Bb2', 46
      define_pitch 'B2', 47
      define_pitch 'C3', 48
      define_pitch 'Db3', 49
      define_pitch 'D3', 50
      define_pitch 'Eb3', 51
      define_pitch 'E3', 52
      define_pitch 'F3', 53
      define_pitch 'Gb3', 54
      define_pitch 'G3', 55
      define_pitch 'Ab3', 56
      define_pitch 'A3', 57
      define_pitch 'Bb3', 58
      define_pitch 'B3', 59
      define_pitch 'C4', 60
      define_pitch 'Db4', 61
      define_pitch 'D4', 62
      define_pitch 'Eb4', 63
      define_pitch 'E4', 64
      define_pitch 'F4', 65
      define_pitch 'Gb4', 66
      define_pitch 'G4', 67
      define_pitch 'Ab4', 68
      define_pitch 'A4', 69
      define_pitch 'Bb4', 70
      define_pitch 'B4', 71
      define_pitch 'C5', 72
      define_pitch 'Db5', 73
      define_pitch 'D5', 74
      define_pitch 'Eb5', 75
      define_pitch 'E5', 76
      define_pitch 'F5', 77
      define_pitch 'Gb5', 78
      define_pitch 'G5', 79
      define_pitch 'Ab5', 80
      define_pitch 'A5', 81
      define_pitch 'Bb5', 82
      define_pitch 'B5', 83
      define_pitch 'C6', 84
      define_pitch 'Db6', 85
      define_pitch 'D6', 86
      define_pitch 'Eb6', 87
      define_pitch 'E6', 88
      define_pitch 'F6', 89
      define_pitch 'Gb6', 90
      define_pitch 'G6', 91
      define_pitch 'Ab6', 92
      define_pitch 'A6', 93
      define_pitch 'Bb6', 94
      define_pitch 'B6', 95
      define_pitch 'C7', 96
      define_pitch 'Db7', 97
      define_pitch 'D7', 98
      define_pitch 'Eb7', 99
      define_pitch 'E7', 100
      define_pitch 'F7', 101
      define_pitch 'Gb7', 102
      define_pitch 'G7', 103
      define_pitch 'Ab7', 104
      define_pitch 'A7', 105
      define_pitch 'Bb7', 106
      define_pitch 'B7', 107
      define_pitch 'C8', 108
      define_pitch 'Db8', 109
      define_pitch 'D8', 110
      define_pitch 'Eb8', 111
      define_pitch 'E8', 112
      define_pitch 'F8', 113
      define_pitch 'Gb8', 114
      define_pitch 'G8', 115
      define_pitch 'Ab8', 116
      define_pitch 'A8', 117
      define_pitch 'Bb8', 118
      define_pitch 'B8', 119
      define_pitch 'C9', 120
      define_pitch 'Db9', 121
      define_pitch 'D9', 122
      define_pitch 'Eb9', 123
      define_pitch 'E9', 124
      define_pitch 'F9', 125
      define_pitch 'Gb9', 126
      define_pitch 'G9', 127

      PITCHES.freeze
      PITCH_NAMES.freeze

    end
  end
end



=begin

Script for generating the define_pitch statements in this file.
Run in the irb console after requiring 'mtk'

128.times do |value|
  pitch = MTK::Core::Pitch.from_i(value)
  octave_str = pitch.octave.to_s.sub(/-/,'_') # '_1' for -1
  name = "#{pitch.pitch_class}#{octave_str}"
  puts "      define_pitch '#{name}', #{value}"
end

=end