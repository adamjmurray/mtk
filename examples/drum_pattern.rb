require 'mtk'
require 'mtk/io/midi_file'
include MTK
include Lang::Pitches
include Lang::Intensities

file = ARGV[0] || "MTK-#{File.basename(__FILE__,'.rb')}.mid"

_ = nil # defines _ as a rest

pattern = {# 0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
  C2  =>  [fff,  _,  _,  _, mf,  _,  _,  _,  f,  _,  _,  _, mp,  _,  _,  _], # kick
  Db2 =>  [  _,  _,  f,  _,  _,  _, mp,  _,  _,  _,  f,  _,  _,  _, mf,  _], # rim shot
  D2  =>  [  _, mp,  _, mp,  _, mp,  _, mf,  _, mp,  _, mp,  _, pp,  _, mf]  # snare
}

timeline = Events::Timeline.new
for pitch,intensities in pattern
  track = Sequencers::StepSequencer( Patterns.Sequence(intensities), default_pitch:pitch, channel:10 )
  timeline.merge track.to_timeline
end

MIDIFile(file).write timeline
