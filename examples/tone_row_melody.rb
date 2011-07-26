# Generate a MIDI file using a tone row, repeated 3 times using random rhythms
#
# NOTE: this blindly overwrites any existing MTK-tone_row_melody.mid file, unless an argument is provided

require 'mtk'
require 'mtk/midi/file'
include MTK
include MTK::Constant::PitchClasses
include MTK::Constant::Durations

file = ARGV[0] || 'MTK-tone_row_melody.mid'

row = PitchClassSet(Db, G, Ab, F, Eb, E, D, C, B, Gb, A, Bb)
pitch_pattern = Pattern.PitchCycle *row
rhythm_pattern = Pattern.DurationCycle(Pattern.Choice s, e, e+s, q) # choose between sixteenth, eighth, dotted eighth, and quarter

sequencer = Sequencer::LegatoSequencer.new [pitch_pattern, rhythm_pattern], :max_steps => 36
timeline = sequencer.to_timeline

MIDI_File(file).write timeline

