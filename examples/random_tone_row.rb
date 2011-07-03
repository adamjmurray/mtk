# Generate a MIDI file of a random 12-tone row
#
# NOTE: this blindly overwrites any existing MTK-random_tone_row.mid file, unless an argument is provided

require 'mtk'
require 'mtk/midi/file'
include MTK

file = ARGV[0] || 'MTK-random_tone_row.mid'

row = PitchClassSet.random_row
sequence = Pattern::PitchSequence *row.to_a

sequencer = Sequencer::StepSequencer.new [sequence]
timeline = sequencer.to_timeline

MIDI_File(file).write timeline

