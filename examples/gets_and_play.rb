# Enter space-separated pitch classes (A,B,C,D,E,F,G) at the prompt and hear them play.

require 'mtk'
require 'mtk/helper/output_selector'
include MTK

output = Helper::OutputSelector.ensure_output ARGV[0]

def get_pitch_classes
  puts "Enter pitch classes:"
  input = STDIN.gets
  input.strip.split(/\s+/).map{|name| PitchClass[name] } if input
rescue
  puts "Invalid input."
end

while (pitch_classes = get_pitch_classes)
  sequence = Pattern::PitchClassSequence *pitch_classes
  sequencer = Sequencer::StepSequencer.new [sequence]
  timeline = sequencer.to_timeline

  puts "Playing: #{pitch_classes}"
  puts "Timeline:\n#{timeline}"
  output.play timeline
end

