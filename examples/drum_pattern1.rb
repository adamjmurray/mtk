require 'mtk'
require 'mtk/midi/file'
include MTK
include Constant::Pitches
include Constant::Intensities

file = ARGV[0] || "MTK-#{File.basename(__FILE__,'.rb')}.mid"

_ = nil # defines _ as a rest

pattern = {# 0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
  C2  =>  [fff,  _,  _,  _, mf,  _,  _,  _,  f,  _,  _,  _, mp,  _,  _,  _], # kick
  Db2 =>  [  _,  _,  f,  _,  _,  _, mp,  _,  _,  _,  f,  _,  _,  _, mf,  _], # snare
  D2  =>  [  _, mp,  _, mp,  _, mp,  _, mf,  _, mp,  _, mp,  _, pp,  _, mf]  # hat
}

timeline = Timeline.new
for pitch,intensities in pattern
  track = Sequencer::StepSequencer.new [Pattern.IntensitySequence(*intensities)], :default_pitch => pitch
  timeline.merge track.to_timeline
end

MIDI_File(file).write timeline
