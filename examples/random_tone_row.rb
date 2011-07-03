# Generate a MIDI file of a random 12-tone row

require 'mtk'
require 'mtk/midi/file'
include MTK

row = PitchClassSet.random_row
sequence = Pattern::PitchSequence *row.to_a

sequencer = Sequencer::StepSequencer.new [sequence]
timeline = sequencer.to_timeline

MIDI_File('12_tone_row.mid').write timeline

