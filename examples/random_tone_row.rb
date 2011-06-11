# Generate a MIDI file of a random 12-tone row

require 'mtk'
require 'mtk/patterns'
require 'mtk/midi/file'
include MTK

row = PitchClassSet.random_row
seq = Pattern::PitchSequence.from_pitch_classes row

timeline = Timeline.new

seq.each_with_index do |pitch, beat_index|
  timeline[beat_index] = Note.new(pitch, Dynamics.mf, 1)
end

MIDI_File('12_tone_row.mid').write timeline

