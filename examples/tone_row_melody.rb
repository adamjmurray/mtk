# Generate a MIDI file using a specific tone row, repeated 3 times using eighth note rhythms
#
# NOTE: this blindly overwrites any existing MTK-tone_row_melody.mid file, unless an argument is provided

require 'mtk'
require 'mtk/midi/file'
include MTK
include PitchClasses

file = ARGV[0] || 'MTK-tone_row_melody.mid'

row = PitchClassSet(Db, G, Ab, F, Eb, E, D, C, B, Gb, A, Bb)
sequence = (Pattern::PitchSequence *row.to_a).repeat(3)

sequencer = Sequencer::StepSequencer.new [sequence], :step_size => 0.8
timeline = sequencer.to_timeline

MIDI_File(file).write timeline

