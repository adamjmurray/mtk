# Generate a MIDI file using a tone row, repeated 3 times using random rhythms
#
# NOTE: this blindly overwrites any existing MTK-tone_row_melody.mid file, unless an argument is provided

require 'mtk'
require 'mtk/io/midi_file'
include MTK
include MTK::Lang::PitchClasses
include MTK::Lang::Durations

file = ARGV[0] || 'MTK-tone_row_melody.mid'

row = PitchClassSet Db, G, Ab, F, Eb, E, D, C, B, Gb, A, Bb
pitch_pattern = Patterns.Cycle *row
rhythm_pattern = Patterns.Choice s, e, e+s, q # choose between sixteenth, eighth, dotted eighth, and quarter

chain = Patterns.Chain pitch_pattern, rhythm_pattern, min_elements: 36, max_elements: 36

sequencer = Sequencers.LegatoSequencer chain
timeline = sequencer.to_timeline

MIDIFile(file).write timeline

