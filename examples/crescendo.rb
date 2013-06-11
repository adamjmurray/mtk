# Generate a MIDI file of the C-major scale with a crescendo (it increases in intensity)
#
# NOTE: this blindly overwrites any existing MTK-crescendo.mid file, unless an argument is provided

require 'mtk'
require 'mtk/midi/file'
include MTK
include Lang::Pitches
include Lang::Intensities

file = ARGV[0] || 'MTK-crescendo.mid'

scale = Patterns.Sequence C4,D4,E4,F4,G4,A4,B4,C5
crescendo = Patterns.Lines pp, [fff, scale.length-1] # step from pp to fff over the length of the scale

sequencer = Sequencers.StepSequencer scale, crescendo
timeline = sequencer.to_timeline

MIDI_File(file).write timeline

