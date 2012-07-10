# Generate a MIDI file of a random 12-tone row
#
# NOTE: this blindly overwrites any existing MTK-random_tone_row.mid file, unless an argument is provided

require 'mtk'
require 'mtk/midi/file'
include MTK

file = ARGV[0] || 'MTK-random_tone_row.mid'

row = PitchClassSet.random_row
sequence = Patterns::PitchSequence *row.to_a

sequencer = Sequencers::StepSequencer.new [sequence]
timeline = sequencer.to_timeline

MIDI_File(file).write timeline

