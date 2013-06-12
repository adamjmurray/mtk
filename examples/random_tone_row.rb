# Generate a MIDI file of a random 12-tone row
#
# NOTE: this blindly overwrites any existing MTK-random_tone_row.mid file, unless an argument is provided

require 'mtk'
require 'mtk/io/midi_file'
include MTK

file = ARGV[0] || 'MTK-random_tone_row.mid'

row = Groups::PitchClassSet.random_row
sequence = Patterns.Sequence *row

sequencer = Sequencers.StepSequencer sequence
timeline = sequencer.to_timeline

MIDIFile(file).write timeline

