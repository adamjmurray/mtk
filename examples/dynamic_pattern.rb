# Generate a MIDI file using a lambda to dynamically generate the pitches
#
# NOTE: this blindly overwrites any existing MTK-dynamic_pattern.mid file, unless an argument is provided

require 'mtk'
require 'mtk/midi/file'
include MTK
include MTK::Constants::Pitches
include MTK::Constants::Intensities
include MTK::Constants::Intervals

file = ARGV[0] || "MTK-#{File.basename(__FILE__,'.rb')}.mid"

interval_generator = lambda do
  # Randomly return intervals
  r = rand
  case
    when r < 0.1 then m2
    when r < 0.4 then M2
    when r < 0.5 then m3
    when r < 0.6 then M3
    when r < 0.7 then P4
    when r < 0.8 then -M3
    when r < 0.95 then -P5
    else -P8
  end
end

pitches = Patterns::Function.new interval_generator, :type => :pitch, :max_elements => 24

# we'll also use a weighted choice to generate the intensities
intensities = Patterns::Choice.new [mp, mf, f, ff, fff], :type => :intensity, :weights => [1,2,3,2,1]


sequencer = Sequencers::StepSequencer.new [pitches, intensities], :step_size => 0.5
timeline = sequencer.to_timeline

MIDI_File(file).write timeline

