require 'mtk'
require 'mtk/midi/file'
include MTK
include Constants::Pitches
include Constants::Intensities

file = ARGV[0] || "MTK-#{File.basename(__FILE__,'.rb')}.mid"

_ = nil # defines _ as a rest

pattern = {# 0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
  C2  =>  [fff,  _,  _,  _, mf,  _,  _,  _,  o,  _,  _,  _, mp,  _,  _,  _], # kick
  Db2 =>  [  _,  _,  o,  _,  _,  _, mp,  _,  _,  _,  o,  _,  _,  _, mf,  _], # snare
  D2  =>  [  _, mp,  _, mp,  _, mp,  _, mf,  _, mp,  _, mp,  _, pp,  _, mf]  # hat
}

timeline = Timeline.new
for pitch,intensities in pattern
  track = Sequencers::StepSequencer( Patterns.Sequence intensities, default_pitch: pitch )
  timeline.merge track.to_timeline
end

MIDI_File(file).write timeline
